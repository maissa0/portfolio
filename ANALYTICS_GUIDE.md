# 📊 Portfolio Analytics Setup & Viewing Guide

## 🚀 Setup Steps

### 1. Create the Database Table
1. Go to your **Supabase Dashboard**
2. Navigate to **SQL Editor**
3. Copy and paste the entire content from `database_setup.sql`
4. Click **Run** to create the table and views

### 2. Deploy Your Portfolio
The `AnalyticsTracker` component is now added to your app and will automatically start collecting data when visitors come to your site.

## 📈 Viewing Your Analytics

### Quick Dashboard View
In Supabase, go to **SQL Editor** and run:
```sql
SELECT * FROM portfolio_dashboard;
```

This gives you an instant overview:
- Total page views
- Unique visitors  
- Views today/week/month
- Mobile vs Desktop breakdown
- Peak hour of visits

### Daily Statistics
```sql
SELECT * FROM daily_stats ORDER BY date DESC LIMIT 30;
```
Shows daily breakdown for the last 30 days.

### Top Countries
```sql
SELECT * FROM top_countries;
```
See where your visitors are coming from.

### Page Popularity
```sql
SELECT * FROM page_popularity;
```
Which pages are most visited.

### Recent Visitors (Last 24 hours)
```sql
SELECT 
    country, 
    city, 
    device_type, 
    page_url,
    visited_at
FROM portfolio_analytics 
WHERE visited_at >= NOW() - INTERVAL '24 hours'
ORDER BY visited_at DESC;
```

### Detailed Analytics Query
```sql
SELECT 
    DATE(visited_at) as date,
    COUNT(*) as total_views,
    COUNT(DISTINCT visitor_id) as unique_visitors,
    COUNT(DISTINCT CASE WHEN referrer != 'Direct' THEN referrer END) as referral_sources,
    ROUND(AVG(CASE WHEN device_type = 'Mobile' THEN 1.0 ELSE 0.0 END) * 100, 1) as mobile_percentage
FROM portfolio_analytics 
GROUP BY DATE(visited_at)
ORDER BY date DESC
LIMIT 7;
```

## 🔍 What Data is Collected

The analytics tracker collects:
- **Visitor Info**: Unique visitor ID, country, city
- **Technical**: Device type, screen resolution, browser language
- **Behavior**: Pages visited, time spent, referrer source
- **Privacy-Friendly**: No personal data, just anonymous usage patterns

## 🎯 Key Metrics to Watch

1. **Unique Visitors**: How many different people visit
2. **Page Views**: Total number of page loads
3. **Geographic Distribution**: Where your audience is
4. **Device Types**: Mobile vs Desktop usage
5. **Popular Pages**: Which sections get most attention
6. **Traffic Sources**: How people find your site

## 🛡️ Privacy & Security

- All data is anonymous
- No personal information stored
- Visitor IDs are randomly generated
- Compliant with privacy regulations
- Only you can access the data in your Supabase dashboard

## 🔄 Real-time Monitoring

To see live visitor activity:
```sql
SELECT 
    country,
    device_type,
    page_url,
    visited_at
FROM portfolio_analytics 
WHERE visited_at >= NOW() - INTERVAL '5 minutes'
ORDER BY visited_at DESC;
```

---

**Once deployed, your portfolio will automatically start collecting anonymous analytics that you can view anytime in your Supabase dashboard!** 🚀