page 50102 "Log Alertas Documentos"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Log Alerta Documento";
    Caption = 'Log de Alertas';
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Alertas)
            {
                field("Nº Movimiento"; Rec."Nº Movimiento") { }
                field("Fecha Alerta"; Rec."Fecha Alerta") { }
                field("Tipo Alerta"; Rec."Tipo Alerta")
                {
                    StyleExpr = EstiloAlerta;
                }
                field("Código Documento"; Rec."Código Documento") { }
                field("Nombre Documento"; Rec."Nombre Documento") { }
                field("Fecha Vencimiento"; Rec."Fecha Vencimiento") { }
                field("Días Restantes"; Rec."Días Restantes") { }
                field("Notificado"; Rec."Notificado") { }
            }
        }
    }

    var
        EstiloAlerta: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Tipo Alerta" = Rec."Tipo Alerta"::Vencido then
            EstiloAlerta := 'Unfavorable'
        else
            EstiloAlerta := 'Ambiguous';
    end;
}