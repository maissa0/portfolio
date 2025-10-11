-- Migration script to add images and video fields to projects table
-- Run this in Supabase SQL Editor

-- Add images column (array of text for multiple image URLs)
ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS images text[] DEFAULT '{}';

-- Add video column (single text field for video URL)
ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS video text DEFAULT NULL;

-- Optional: Add comments to document the new columns
COMMENT ON COLUMN projects.images IS 'Array of image URLs for project gallery';
COMMENT ON COLUMN projects.video IS 'Video URL for project demo (YouTube, Vimeo, or direct file)';

-- Optional: Update existing projects to have empty arrays for images
-- (This ensures consistency, but NULL values also work)
UPDATE projects 
SET images = '{}' 
WHERE images IS NULL;

-- Verify the changes
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'projects' 
AND column_name IN ('images', 'video');