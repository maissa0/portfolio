# Media Upload Guide for Portfolio Projects

## Setting Up Supabase Storage

### 1. Create Storage Buckets

1. Go to your Supabase Dashboard
2. Navigate to **Storage** in the sidebar
3. Click **New Bucket**
4. Create two buckets:
   - Name: `project-images` (Public: ✅)
   - Name: `project-videos` (Public: ✅)

### 2. Upload Your Media Files

#### For Images:
1. Go to Storage → `project-images` bucket
2. Create folders for organization (optional):
   ```
   project-1/
   project-2/
   project-3/
   ```
3. Upload your images (JPG, PNG, WebP recommended)
4. Copy the public URLs

#### For Videos:
1. Go to Storage → `project-videos` bucket
2. Upload your videos (MP4 recommended for web compatibility)
3. Copy the public URLs

**Note:** Keep file sizes reasonable:
- Images: Under 2MB each (optimize for web)
- Videos: Under 50MB (consider compression)

### 3. File Naming Convention

Use descriptive, URL-friendly names:
```
project-1-hero.jpg
project-1-gallery-1.jpg
project-1-gallery-2.jpg
project-1-demo.mp4
```

### 4. Update Database

After uploading, update your projects table:

```sql
-- Example for a project with multiple images and video
UPDATE projects 
SET 
  images = '[
    "https://your-project.supabase.co/storage/v1/object/public/project-images/project-1-gallery-1.jpg",
    "https://your-project.supabase.co/storage/v1/object/public/project-images/project-1-gallery-2.jpg",
    "https://your-project.supabase.co/storage/v1/object/public/project-images/project-1-gallery-3.jpg"
  ]'::jsonb,
  video = 'https://your-project.supabase.co/storage/v1/object/public/project-videos/project-1-demo.mp4'
WHERE id = 1;
```

### 5. Alternative: Use Text Array for Images

If you prefer text arrays over JSONB:

```sql
-- Using text array instead of JSONB
UPDATE projects 
SET 
  images = ARRAY[
    'https://your-project.supabase.co/storage/v1/object/public/project-images/project-1-gallery-1.jpg',
    'https://your-project.supabase.co/storage/v1/object/public/project-images/project-1-gallery-2.jpg'
  ],
  video = 'https://your-project.supabase.co/storage/v1/object/public/project-videos/project-1-demo.mp4'
WHERE id = 1;
```

## Image Optimization Tips

### Before Uploading:
1. **Resize images** to appropriate dimensions:
   - Gallery images: 1200x800px max
   - Thumbnails: 400x300px
2. **Compress images** using tools like:
   - [TinyPNG](https://tinypng.com/)
   - [Squoosh](https://squoosh.app/)
3. **Use modern formats**:
   - WebP for better compression
   - AVIF if supported

### Video Optimization:
1. **Compress videos** using:
   - HandBrake (free)
   - FFmpeg
2. **Keep duration short**: 30-60 seconds for demos
3. **Use web-optimized settings**:
   - H.264 codec
   - 1080p max resolution
   - 30fps

## Programmatic Upload (Advanced)

If you have many files, you can upload programmatically:

```javascript
import { createClient } from '@supabase/supabase-js';

const supabase = createClient('your-url', 'your-anon-key');

async function uploadFile(file, bucket, path) {
  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(path, file);
    
  if (error) {
    console.error('Error uploading file:', error);
    return null;
  }
  
  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from(bucket)
    .getPublicUrl(path);
    
  return publicUrl;
}

// Usage
const imageUrl = await uploadFile(imageFile, 'project-images', 'project-1-gallery-1.jpg');
const videoUrl = await uploadFile(videoFile, 'project-videos', 'project-1-demo.mp4');
```

## Security Notes

- Storage buckets are set to public for easy access
- Consider implementing upload restrictions in production
- Monitor storage usage in Supabase dashboard
- Set up proper CORS if needed

## Cost Considerations

- Supabase storage pricing: $0.021 per GB per month
- 1GB free tier included
- Consider image/video optimization to reduce costs