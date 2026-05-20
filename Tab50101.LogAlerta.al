table 50101 "Log Alerta Documento"
{
    Caption = 'Log de Alertas de Documentos';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Nº Movimiento"; Integer)
        {
            Caption = 'Nº Movimiento';
            AutoIncrement = true;
        }
        field(2; "Fecha Alerta"; DateTime)
        {
            Caption = 'Fecha de Alerta';
        }
        field(3; "Código Documento"; Code[20])
        {
            Caption = 'Código Documento';
        }
        field(4; "Nombre Documento"; Text[100])
        {
            Caption = 'Nombre Documento';
        }
        field(5; "Fecha Vencimiento"; Date)
        {
            Caption = 'Fecha Vencimiento';
        }
        field(6; "Tipo Alerta"; Option)
        {
            Caption = 'Tipo de Alerta';
            OptionMembers = " ","Por vencer","Vencido";
            OptionCaption = ' ,Por vencer,Vencido';
        }
        field(7; "Días Restantes"; Integer)
        {
            Caption = 'Días Restantes';
        }
        field(8; "Notificado"; Boolean)
        {
            Caption = 'Notificado por Email';
        }
    }

    keys
    {
        key(PK; "Nº Movimiento")
        {
            Clustered = true;
        }
    }
}