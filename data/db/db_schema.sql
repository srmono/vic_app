-- STEP 1: CREATE DATABASE
CREATE DATABASE IF NOT EXISTS vasavi_info_center;
USE vasavi_info_center;

-- STEP 2: DROP TABLES IN DEPENDENCY ORDER
DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS post_categories;
DROP TABLE IF EXISTS uploads;
DROP TABLE IF EXISTS city_section_promoters;
DROP TABLE IF EXISTS service_units;
DROP TABLE IF EXISTS city_sections;
DROP TABLE IF EXISTS classifieds;
DROP TABLE IF EXISTS business_listings;
DROP TABLE IF EXISTS business_categories;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS admin_centers;
DROP TABLE IF EXISTS sections;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS locations;

-- STEP 3: CREATE TABLES

-- 1. LOCATIONS TABLE
CREATE TABLE locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id INT NULL,
    type ENUM('Country', 'State', 'District', 'City') NOT NULL,
    status TINYINT DEFAULT 1,
    FOREIGN KEY (parent_id) REFERENCES locations(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 2. USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role ENUM('Chairman', 'Coordinator', 'Promoter', 'Member') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    profile_image JSON,
    location_id INT,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. SECTIONS TABLE
CREATE TABLE sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. CITY SECTIONS TABLE
CREATE TABLE city_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_id INT NOT NULL,
    section_id INT NOT NULL,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES locations(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. SERVICE UNITS TABLE
CREATE TABLE service_units (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_section_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    phone VARCHAR(15),
    management_contact JSON,
    images JSON,
    address TEXT,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_section_id) REFERENCES city_sections(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. CITY SECTION PROMOTERS TABLE
CREATE TABLE city_section_promoters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_section_id INT NOT NULL,
    promoter_user_id INT NOT NULL,
    contact_info JSON,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_section_id) REFERENCES city_sections(id) ON DELETE CASCADE,
    FOREIGN KEY (promoter_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. UPLOADS TABLE
CREATE TABLE uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uploader_id INT NOT NULL,
    service_unit_id INT,
    file_path JSON,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_unit_id) REFERENCES service_units(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. EVENTS TABLE
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE,
    location_id INT,
    created_by INT,
    image_path JSON,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- 9. SUBSCRIPTIONS TABLE
CREATE TABLE subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 10. BUSINESS CATEGORIES TABLE
CREATE TABLE business_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    status TINYINT DEFAULT 1
) ENGINE=InnoDB;

-- 11. BUSINESS LISTINGS TABLE
CREATE TABLE business_listings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT,
    business_name VARCHAR(255) NOT NULL,
    description TEXT,
    phone VARCHAR(15),
    email VARCHAR(255),
    website VARCHAR(255),
    location_id INT,
    logo_path JSON,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES business_categories(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
) ENGINE=InnoDB;

-- 12. CLASSIFIEDS TABLE
CREATE TABLE classifieds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('Job', 'Business') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location_id INT,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(15),
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
) ENGINE=InnoDB;

-- 13. ADMIN CENTERS TABLE
CREATE TABLE admin_centers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location_id INT NOT NULL,
    admin_user_id INT NOT NULL,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 14. POST CATEGORIES TABLE (for Blog/News)
CREATE TABLE post_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status TINYINT DEFAULT 1
) ENGINE=InnoDB;

-- 15. POSTS TABLE (for Blog/News Articles)
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    category_id INT,
    author_id INT,
    image JSON,
    is_published TINYINT DEFAULT 0,
    published_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES post_categories(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 16. POST TAGS TABLE (for future tagging)
CREATE TABLE post_tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    tag VARCHAR(50) NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB;
