-- Insert dummy data into stloos_images table
-- Note: These URLs will be updated to point to actual storage URLs after uploading images

insert into public.stloos_images (name, url) values
(
    'image1',
    'http://192.168.0.192:54321/storage/v1/object/public/stloos-images/image1.jpeg'
),
(
    'image2',
    'http://192.168.0.192:54321/storage/v1/object/public/stloos-images/image2.jpeg'
),
(
    'image3',
    'http://192.168.0.192:54321/storage/v1/object/public/stloos-images/image3.jpeg'
);
