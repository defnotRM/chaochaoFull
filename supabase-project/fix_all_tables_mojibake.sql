-- ============================================================================
-- สคริปต์แก้ภาษาต่างดาว (Mojibake) ในทุกตารางของ Supabase (Local)
-- ============================================================================

-- 1. itemlocation
UPDATE public.itemlocation SET
  description = 'BTS สยาม / สยามพารากอน',
  alley = 'ซอย 5',
  road = 'พระราม 1',
  subdistrict = 'ปทุมวัน',
  district = 'ปทุมวัน',
  province = 'กรุงเทพมหานคร'
WHERE location_id = '11111111-1111-1111-1111-111111111111';

UPDATE public.itemlocation SET
  description = 'ฟิวเจอร์พาร์ค รังสิต',
  alley = 'ซอยรังสิต 2',
  road = 'พหลโยธิน',
  subdistrict = 'ประชาธิปัตย์',
  district = 'ธัญบุรี',
  province = 'ปทุมธานี'
WHERE location_id = '22222222-2222-2222-2222-222222222222';

UPDATE public.itemlocation SET
  description = 'เซ็นทรัล ลาดพร้าว / MRT พหลโยธิน',
  alley = 'ซอย 71',
  road = 'ลาดพร้าว',
  subdistrict = 'สะพานสอง',
  district = 'วังทองหลาง',
  province = 'กรุงเทพมหานคร'
WHERE location_id = '33333333-3333-3333-3333-333333333333';

UPDATE public.itemlocation SET
  description = 'BTS ช่องนนทรี / สาทร',
  alley = '',
  road = 'สาทรเหนือ',
  subdistrict = 'สีลม',
  district = 'บางรัก',
  province = 'กรุงเทพมหานคร'
WHERE location_id = '44444444-4444-4444-4444-444444444444';

-- 2. itemcondition
UPDATE public.itemcondition SET condition = 'คืนอุปกรณ์ตามเวลาที่นัดหมาย' WHERE item_id = 'b1111111-1111-1111-1111-111111111111' AND seq = 1;
UPDATE public.itemcondition SET condition = 'ห้ามนำไปใช้ในที่เปียกชื้นหรือฝนตกหนัก' WHERE item_id = 'b1111111-1111-1111-1111-111111111111' AND seq = 2;
UPDATE public.itemcondition SET condition = 'กรุณาระวังหลอดไฟแตกมาระหว่างขนย้าย' WHERE item_id = 'b3333333-3333-3333-3333-333333333333' AND seq = 1;
UPDATE public.itemcondition SET condition = 'กรุณาทำความสะอาดก่อนคืน' WHERE item_id = 'b4444444-4444-4444-4444-444444444444' AND seq = 1;

-- 3. review
UPDATE public.review SET comment = 'กล้องสภาพดีมาก เจ้าของนัดหมายตรงเวลา แนะนำเลยครับ' WHERE order_id = 'd1111111-1111-1111-1111-111111111111';

-- 4. rentalorder
UPDATE public.rentalorder SET
  meetup_location = 'BTS ช่องนนทรี / สาทร',
  return_location = 'BTS ช่องนนทรี / สาทร'
WHERE order_id = 'da1acdef-59d2-498e-a329-90783857c403';

-- 5. message
UPDATE public.message SET content = 'สวัสดีครับ สนใจเช่ากล้องช่วง 20-23 ก.ค. นี้ครับ ว่างไหมครับ' WHERE message_id = 'd4da6dd4-ba88-47ef-93c9-9057db9b4a23';
UPDATE public.message SET content = 'ได้ครับ พรุ่งนี้เจอกันตามนัดเลยครับ' WHERE message_id = '8e08c786-5ba6-451f-8df3-1b5153d0c5df';
UPDATE public.message SET content = 'ดีครับพี่' WHERE message_id = '648d220c-bb1b-42c0-83ac-53cc4b200ff3';
UPDATE public.message SET content = 'อะไร' WHERE message_id = 'e8f98f30-359b-4bf6-a7c0-b1c51e7689d8';
UPDATE public.message SET content = 'ขายกล้องไหม' WHERE message_id = '00aa508d-0d67-4670-acb2-40a5929990e5';
UPDATE public.message SET content = 'ไม่ขาย' WHERE message_id = '8acd105f-8732-4aab-a4a0-5374ce5bf7cb';
UPDATE public.message SET content = 'แฟนต้าตัวจริงไหม' WHERE message_id = 'b29b326e-cfc6-4cd8-b335-77a9236c4ade';
UPDATE public.message SET content = 'จริงดิ' WHERE message_id = '874e0df8-862e-4b5e-b92f-e40639498b42';
UPDATE public.message SET content = 'ไม่เชื่อก็ตามใจ' WHERE message_id = 'eb2a48fe-3cbb-4dc5-8e8e-248fd680fdb1';
UPDATE public.message SET content = 'ขอโทษครับพี่' WHERE message_id = 'f66d055b-2913-4bdc-9e77-cdc685ecb992';
UPDATE public.message SET content = 'หวัดดี' WHERE message_id = 'd17cc557-2063-437d-a884-c66f40c082d3';
UPDATE public.message SET content = 'หวัดดีไร' WHERE message_id = '77bb470e-274a-405e-9a0e-d581bda78f7e';
UPDATE public.message SET content = 'หวัดดีหยก' WHERE message_id = '0b9dc486-206d-46fc-9c9e-d882344785be';
