codeunit 50100 "Revisar Documentos"
{
    trigger OnRun()
    var
        Config: Record "Config Alerta Certificados";
    begin
        if Config.Get('SETUP') then
            ComprobarCertificados(Config."Días Antelación")
        else
            ComprobarCertificados(30);
    end;

    procedure ComprobarCertificados(DiasAntelacion: Integer)
    var
        Cert: Record "Isolated Certificate";
        FechaLimite: Date;
        FechaVenc: Date;
        DiasRestantes: Integer;
        Vencidos: Integer;
        PorVencer: Integer;
        CuerpoEmail: Text;
        HayAlertas: Boolean;
    begin
        FechaLimite := Today + DiasAntelacion;
        CuerpoEmail := '';

        Cert.Reset();
        if Cert.FindSet() then
            repeat
                if Cert."Expiry Date" <> 0DT then begin
                    FechaVenc := DT2Date(Cert."Expiry Date");
                    DiasRestantes := FechaVenc - Today;

                    if DiasRestantes < 0 then begin
                        if not YaAlertadoReciente(Cert.Code) then begin
                            Vencidos += 1;
                            HayAlertas := true;
                            RegistrarAlerta(Cert.Code, Cert.Name, FechaVenc, 2, DiasRestantes);
                            CuerpoEmail += StrSubstNo(
                                '<tr style="background-color:#fcebeb"><td style="padding:8px">%1</td><td style="padding:8px">%2</td><td style="padding:8px">%3</td><td style="padding:8px"><strong>VENCIDO hace %4 días</strong></td></tr>',
                                Cert.Code, Cert.Name, Format(FechaVenc), Format(-DiasRestantes));
                        end;
                    end else if DiasRestantes <= DiasAntelacion then begin
                        if not YaAlertadoReciente(Cert.Code) then begin
                            PorVencer += 1;
                            HayAlertas := true;
                            RegistrarAlerta(Cert.Code, Cert.Name, FechaVenc, 1, DiasRestantes);
                            CuerpoEmail += StrSubstNo(
                                '<tr style="background-color:#faeeda"><td style="padding:8px">%1</td><td style="padding:8px">%2</td><td style="padding:8px">%3</td><td style="padding:8px">Vence en %4 días</td></tr>',
                                Cert.Code, Cert.Name, Format(FechaVenc), Format(DiasRestantes));
                        end;
                    end;
                end;
            until Cert.Next() = 0;

        if HayAlertas then
            EnviarEmail(Vencidos, PorVencer, CuerpoEmail);
    end;

    local procedure YaAlertadoReciente(CodCert: Code[20]): Boolean
    var
        LogAlerta: Record "Log Alerta Documento";
        Config: Record "Config Alerta Certificados";
        Cert: Record "Isolated Certificate";
        FrecuenciaDias: Integer;
        FechaVenc: Date;
        DiasRestantes: Integer;
    begin
        FrecuenciaDias := 5;
        if Config.Get('SETUP') and (Config."Frecuencia Días" > 0) then
            FrecuenciaDias := Config."Frecuencia Días";

        // Últimos 3 días: alertar diariamente
        if Cert.Get(CodCert) and (Cert."Expiry Date" <> 0DT) then begin
            FechaVenc := DT2Date(Cert."Expiry Date");
            DiasRestantes := FechaVenc - Today;
            if (DiasRestantes >= 0) and (DiasRestantes <= 3) then
                FrecuenciaDias := 1;
        end;

        LogAlerta.Reset();
        LogAlerta.SetRange("Código Documento", CodCert);
        LogAlerta.SetFilter("Fecha Alerta", '%1..', CreateDateTime(Today - FrecuenciaDias + 1, 0T));
        exit(not LogAlerta.IsEmpty());
    end;

    local procedure RegistrarAlerta(CodDoc: Code[20]; NomDoc: Text[50]; FechaVenc: Date; TipoAlerta: Integer; Dias: Integer)
    var
        LogAlerta: Record "Log Alerta Documento";
    begin
        LogAlerta.Init();
        LogAlerta."Fecha Alerta" := CurrentDateTime;
        LogAlerta."Código Documento" := CodDoc;
        LogAlerta."Nombre Documento" := NomDoc;
        LogAlerta."Fecha Vencimiento" := FechaVenc;
        LogAlerta."Tipo Alerta" := TipoAlerta;
        LogAlerta."Días Restantes" := Dias;
        LogAlerta."Notificado" := true;
        LogAlerta.Insert(true);
    end;

    local procedure EnviarEmail(Vencidos: Integer; PorVencer: Integer; TablaHTML: Text)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailAccountRec: Record "Email Account";
        EmailAccount: Codeunit "Email Account";
        Config: Record "Config Alerta Certificados";
        Asunto: Text;
        Cuerpo: Text;
        Destinatarios: List of [Text];
        ListaEmails: Text;
        PosicionSeparador: Integer;
    begin
        EmailAccount.GetAllAccounts(false, EmailAccountRec);
        if EmailAccountRec.IsEmpty() then begin
            Message('Alerta registrada en el Log pero no hay cuenta de email configurada.');
            exit;
        end;

        // Leer destinatarios de la configuración
        if Config.Get('SETUP') and (Config."Email Destinatario" <> '') then begin
            ListaEmails := Config."Email Destinatario";
            while StrLen(ListaEmails) > 0 do begin
                PosicionSeparador := StrPos(ListaEmails, ';');
                if PosicionSeparador > 0 then begin
                    Destinatarios.Add(CopyStr(ListaEmails, 1, PosicionSeparador - 1));
                    ListaEmails := CopyStr(ListaEmails, PosicionSeparador + 1);
                end else begin
                    Destinatarios.Add(ListaEmails);
                    ListaEmails := '';
                end;
            end;
        end else
            exit;

        Asunto := StrSubstNo('Alerta certificados: %1 vencido(s), %2 por vencer', Vencidos, PorVencer);

        Cuerpo :=
            '<html><body style="font-family:Segoe UI,Arial,sans-serif">' +
            '<h2 style="color:#333">Alerta de certificados</h2>' +
            '<p>Se han detectado las siguientes incidencias, no olvide renovar y/o cargar un certificado valido.</p>' +
            '<table style="border-collapse:collapse;width:100%">' +
            '<tr style="background-color:#333;color:#fff">' +
            '<th style="padding:8px;text-align:left">Código</th>' +
            '<th style="padding:8px;text-align:left">Nombre</th>' +
            '<th style="padding:8px;text-align:left">Fecha vencimiento</th>' +
            '<th style="padding:8px;text-align:left">Estado</th></tr>' +
            TablaHTML +
            '</table>' +
            '<p style="color:#666;margin-top:20px">Este email se ha generado automáticamente desde Business Central.</p>' +
            '</body></html>';

        EmailMessage.Create(Destinatarios, Asunto, Cuerpo, true);
        Email.Send(EmailMessage);
    end;
}