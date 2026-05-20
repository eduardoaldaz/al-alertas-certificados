page 50103 "Config Alerta Certificados"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Config Alerta Certificados";
    Caption = 'Configuración Alertas Certificados';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Configuración';
                field("Email Destinatario"; Rec."Email Destinatario")
                {
                    ApplicationArea = All;
                    ToolTip = 'Emails que recibirán las alertas. Separar múltiples con punto y coma (;)';
                }
                field("Días Antelación"; Rec."Días Antelación")
                {
                    ApplicationArea = All;
                    ToolTip = 'Con cuántos días de antelación avisar antes del vencimiento.';
                }
                field("Frecuencia Días"; Rec."Frecuencia Días")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enviar alerta cada X días';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec."Cód." := 'SETUP';
            Rec."Días Antelación" := 30;
            Rec.Insert();
        end;
    end;
}