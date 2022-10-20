class ParkingsController < ApplicationController
  # Step1: 顯示開始停車的表單
  def new
    @parking = Parking.new
  end

  # Step2: 新建一筆停車，紀錄下開始時間
  def create
    @parking = Parking.new(parking_type: "guest", start_at: Time.now)
    @parking.save!

    redirect_to parking_path(@parking)
  end

  # Step3: 如果還沒結束，顯示結束停車的表單
  # Step5: 如果已經結束，顯示停車費用。
  def show
    @parking = Parking.find(params[:id])
  end

  # Step4: 結束一筆停車，記錄下結束時間，並且計算停車費
  def update
    @parking = Parking.find(params[:id])
    @parking.end_at = Time.now
    @parking.calculate_amount # 這個方法會計算費用

    @parking.save!

    redirect_to parking_path(@parking)
  end
end
