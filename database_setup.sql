-- Portfolio Analytics Setup for Supabase
-- Copy and paste this entire script into your Supabase SQL Editor

-- Create the main analytics table
CREATE TABLE IF NOT EXISTS portfolio_analytics (
    id SERIAL PRIMARY KEY,
    visitor_id VARCHAR(255) NOT NULL,
    page_url VARCHAR(500),
    page_title VARCHAR(255),
    referrer VARCHAR(500),
    user_agent TEXT,
    screen_resolution VARCHAR(50),
    viewport_size VARCHAR(50),
    language VARCHAR(20),
    timezone VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    ip_address VARCHAR(50),
    device_type VARCHAR(20),
    session_start BOOLEAN DEFAULT FALSE,
    visited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_portfolio_analytics_visitor_id ON portfolio_analytics(visitor_id);
CREATE INDEX IF NOT EXISTS idx_portfolio_analytics_visited_at ON portfolio_analytics(visited_at);
CREATE INDEX IF NOT EXISTS idx_portfolio_analytics_page_url ON portfolio_analytics(page_url);
CREATE INDEX IF NOT EXISTS idx_portfolio_analytics_country ON portfolio_analytics(country);
CREATE INDEX IF NOT EXISTS idx_portfolio_analytics_device_type ON portfolio_analytics(device_type);

-- Enable Row Level Security
ALTER TABLE portfolio_analytics ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to insert data (visitors can record their visits)
CREATE POLICY "Allow anonymous inserts" ON portfolio_analytics
    FOR INSERT 
    TO anon 
    WITH CHECK (true);

-- Allow public read access for testing (you can restrict this later)
CREATE POLICY "Allow public selects" ON portfolio_analytics
    FOR SELECT 
    TO anon, authenticated 
    USING (true);

-- Create a simple dashboard view
CREATE OR REPLACE VIEW portfolio_dashboard AS
SELECT 
    COUNT(*) as total_page_views,
    COUNT(DISTINCT visitor_id) as unique_visitors,
    COUNT(*) FILTER (WHERE visited_at >= NOW() - INTERVAL '24 hours') as views_today,
    COUNT(DISTINCT visitor_id) FILTER (WHERE visited_at >= NOW() - INTERVAL '24 hours') as unique_today,
    COUNT(*) FILTER (WHERE visited_at >= NOW() - INTERVAL '7 days') as views_week,
    COUNT(DISTINCT visitor_id) FILTER (WHERE visited_at >= NOW() - INTERVAL '7 days') as unique_week,
    COUNT(*) FILTER (WHERE device_type = 'Mobile') as mobile_views,
    COUNT(*) FILTER (WHERE device_type = 'Desktop') as desktop_views
FROM portfolio_analytics;

-- Create daily stats view
CREATE OR REPLACE VIEW daily_stats AS
SELECT 
    DATE(visited_at) as date,
    COUNT(*) as total_views,
    COUNT(DISTINCT visitor_id) as unique_visitors,
    COUNT(*) FILTER (WHERE device_type = 'Mobile') as mobile_views,
    COUNT(*) FILTER (WHERE device_type = 'Desktop') as desktop_views
FROM portfolio_analytics
GROUP BY DATE(visited_at)
ORDER BY date DESC;

-- Create top countries view
CREATE OR REPLACE VIEW top_countries AS
SELECT 
    country,
    COUNT(*) as views,
    COUNT(DISTINCT visitor_id) as unique_visitors
FROM portfolio_analytics
WHERE country != 'Unknown'
GROUP BY country
ORDER BY views DESC
LIMIT 10;

-- Grant access to views
GRANT SELECT ON portfolio_dashboard TO anon, authenticated;
GRANT SELECT ON daily_stats TO anon, authenticated;
GRANT SELECT ON top_countries TO anon, authenticated;