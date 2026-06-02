permissionset 50100 "GFL Alertas Cert"
{
    Assignable = true;
    Caption = 'GFL Alertas Certificados';

    Permissions =
        table "Log Alerta Documento" = X,
        tabledata "Log Alerta Documento" = RIMD,
        table "Config Alerta Certificados" = X,
        tabledata "Config Alerta Certificados" = RIMD,
        codeunit "Revisar Documentos" = X;
}