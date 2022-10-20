class CreateParkings < ActiveRecord::Migration[7.0]
  def change
    create_table :parkings do |t|
      t.string :parking_type  # 費率類型: guest, short-term, long-term
      t.datetime :start_at    # 開始時間
      t.datetime :end_at      # 結束時間
      t.integer :amount       # 總金額(分)
      t.integer :user_id, :index => true
      t.timestamps
    end
  end
end
