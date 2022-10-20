require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do
    it "is invalid without amount" do
      parking = Parking.new(parking_type: "guest",
        start_at: Time.now - 6.hours,
        end_at: Time.now)
      expect(parking).not_to be_valid
    end

    it "is invalid without end_at" do
      parking = Parking.new(parking_type: "guest",
        start_at: Time.now - 6.hours,
        amount: 999)
      expect(parking).not_to be_valid
    end
  end

  describe ".calculate_amount" do
    before(:each) do
      # 把每個測試都會用到的 @time 提取出來，這個 before 區塊會在這個 describe 內的所有測試前執行
      @time = Time.new(2017, 3, 27, 8, 0, 0) # 固定一個時間比 Time.now 更好，這樣每次跑測試才能確保一樣的結果
    end

    context "when guest" do
      before(:each) do
        # 把每個測試都會用到的 @parking 提取出來，這個 before 區塊會在這個 context 內的所有測試前執行
        @parking = Parking.new(parking_type: "guest", user: @user,
          start_at: @time)
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥3" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "90 mins should be ¥3" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "120 mins should be ¥4" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(400)
      end
    end

    context "when short-term" do
      before(:each) do
        @user = User.create(email: "test@example.com", password: "123456")
        @parking = Parking.new(parking_type: "short-term", user: @user, start_at: @time)
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥2.5" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)
      end

      it "90 mins should be ¥2.5" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)
      end

      it "120 mins should be ¥3" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end
    end
  end
end
