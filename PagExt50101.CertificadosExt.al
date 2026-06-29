pageextension 50101 "Certificados Ext" extends "Certificate List"
{
    actions
    {
        addlast(Processing)
        {
            action(ComprobarCertificados)
            {
                ApplicationArea = All;
                Caption = 'Comprobar caducidad';
                ToolTip = 'Revisa los certificados y envía un email si alguno está vencido o próximo a vencer.';
                Image = Warning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Revisar: Codeunit "Revisar Documentos";
                begin
                    Revisar.ComprobarCertificados(7, 30);
                    Message('Revisión completada. Consulta el Log de Alertas y tu email.');
                end;
            }
        }
    }
}