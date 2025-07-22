-- Insert dummy data into stloos_images table
-- Note: These URLs will be updated to point to actual storage URLs after uploading images

INSERT INTO public.stloos_images (name, url) VALUES 
('image1', 'http://127.0.0.1:54321/storage/v1/object/public/stloos-images/image1.jpeg'),
('image2', 'http://127.0.0.1:54321/storage/v1/object/public/stloos-images/image2.jpeg'),
('image3', 'http://127.0.0.1:54321/storage/v1/object/public/stloos-images/image3.jpeg');