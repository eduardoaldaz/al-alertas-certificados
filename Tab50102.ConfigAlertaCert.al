table 50102 "Config Alerta Certificados"
{
    Caption = 'Configuración Alertas Certificados';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Cód."; Code[10])
        {
            Caption = 'Código';
        }
        field(2; "Email Destinatario"; Text[250])
        {
            Caption = 'Email destinatario (separar con ;)';
        }
        field(3; "Días Antelación"; Integer)
        {
            Caption = 'Días de antelación';
            InitValue = 30;
        }
        field(4; "Frecuencia Días"; Integer)
        {
            Caption = 'Enviar alerta cada X días';
            InitValue = 5;
        }
    }

    keys
    {
        key(PK; "Cód.")
        {
            Clustered = true;
        }
    }
}