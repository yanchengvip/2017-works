json.extract! supplier_report_form, :id, :provider_id, :date, :trade_amount, :express_amount, :other_fee, :total_amount, :status, :user_id, :created_at, :updated_at
json.url supplier_report_form_url(supplier_report_form, format: :json)
