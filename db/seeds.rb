rooms = FactoryBot.create_list(:room, 4)

rooms.each do |room|
  FactoryBot.create(:appointment, room: room, start_at: 1.business_hour.from_now, end_at: 2.business_hour.from_now)
  FactoryBot.create(:appointment, room: room, start_at: 5.business_hour.from_now, end_at: 7.business_hour.from_now)
end