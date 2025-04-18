# 📘 **Database Documentation – Vasavi Info Center**

## 📂 **Database**: `vasavi_info_center`

This database powers the **Vasavi Info Center**, a platform designed to organize information about locations, services, community sections, user roles, business listings, events, classifieds, and a future-ready blogging system. The schema supports structured content, roles & permissions, multimedia uploads, and extendibility.

---

## 🔧 TABLE-BY-TABLE DOCUMENTATION

---

### 1. **locations**
Represents a hierarchical structure of places (Country → State → District → City).

| Column        | Type               | Description                                  |
|---------------|--------------------|----------------------------------------------|
| id            | INT (PK)           | Unique identifier                            |
| name          | VARCHAR(255)       | Name of the location                         |
| parent_id     | INT (FK)           | References parent location                   |
| type          | ENUM               | Location level: Country/State/District/City  |
| status        | TINYINT            | 1 = active, 0 = inactive                      |

🔁 *Self-referencing FK enables nested location trees.*

---

### 2. **users**
Stores platform users and their roles within the organization.

| Column         | Type             | Description                                   |
|----------------|------------------|-----------------------------------------------|
| id             | INT (PK)         | User ID                                        |
| name           | VARCHAR(255)     | Full name                                     |
| role           | ENUM             | Chairman / Coordinator / Promoter / Member    |
| phone          | VARCHAR(15)      | Unique phone number                           |
| email          | VARCHAR(255)     | Email (optional, unique)                      |
| password_hash  | VARCHAR(255)     | Encrypted password                            |
| profile_image  | JSON             | Stores image URLs (`original`, `thumb`)       |
| location_id    | INT (FK)         | Associated location                           |
| status         | TINYINT          | 1 = active, 0 = inactive                       |
| created_at     | TIMESTAMP        | Record creation timestamp                     |

---

### 3. **sections**
Represents organizational or social sections (e.g. youth wing, senior citizens).

| Column       | Type             | Description                |
|--------------|------------------|----------------------------|
| id           | INT (PK)         | Unique section ID          |
| name         | VARCHAR(255)     | Section name               |
| description  | TEXT             | Details about the section  |
| status       | TINYINT          | Active/inactive flag       |
| created_at   | TIMESTAMP        | Timestamp of creation      |

---

### 4. **city_sections**
Maps a **section** to a specific **city** (e.g. “Youth Section” in “Hyderabad”).

| Column         | Type         | Description                        |
|----------------|--------------|------------------------------------|
| id             | INT (PK)     | Unique ID                          |
| city_id        | INT (FK)     | Reference to `locations` table     |
| section_id     | INT (FK)     | Reference to `sections` table      |
| status         | TINYINT      | Active/inactive                    |
| created_at     | TIMESTAMP    | Creation time                      |

---

### 5. **service_units**
Units providing services in a city-section (like blood banks, transport help, etc).

| Column            | Type         | Description                                  |
|-------------------|--------------|----------------------------------------------|
| id                | INT (PK)     | Service ID                                   |
| city_section_id   | INT (FK)     | Reference to `city_sections`                 |
| name              | VARCHAR      | Service name                                 |
| contact_person    | VARCHAR      | Main contact                                 |
| phone             | VARCHAR      | Contact number                               |
| management_contact| JSON         | Management team contact details              |
| images            | JSON         | Image URLs                                   |
| address           | TEXT         | Physical address                             |
| status            | TINYINT      | Active/inactive                              |
| created_at        | TIMESTAMP    | Record creation                              |

---

### 6. **city_section_promoters**
Assigns **users** as **promoters** to a city section.

| Column            | Type         | Description                                |
|-------------------|--------------|--------------------------------------------|
| id                | INT (PK)     | ID                                          |
| city_section_id   | INT (FK)     | Refers `city_sections`                     |
| promoter_user_id  | INT (FK)     | Refers `users`                             |
| contact_info      | JSON         | Extra contact details                      |
| status            | TINYINT      | 1=active, 0=inactive                        |
| created_at        | TIMESTAMP    | Timestamp                                  |

---

### 7. **uploads**
Tracks user-uploaded files (e.g., event photos, service flyers).

| Column          | Type         | Description                          |
|-----------------|--------------|--------------------------------------|
| id              | INT (PK)     | Upload ID                            |
| uploader_id     | INT (FK)     | User who uploaded                    |
| service_unit_id | INT (FK)     | Associated service (optional)        |
| file_path       | JSON         | File paths (`original`, `thumb`)     |
| uploaded_at     | TIMESTAMP    | Upload time                          |

---

### 8. **events**
Community-wide or city-specific events.

| Column        | Type         | Description                           |
|---------------|--------------|---------------------------------------|
| id            | INT (PK)     | Event ID                              |
| title         | VARCHAR      | Title of the event                    |
| description   | TEXT         | Event details                         |
| event_date    | DATE         | Scheduled date                        |
| location_id   | INT (FK)     | Event location                        |
| created_by    | INT (FK)     | Event organizer                       |
| image_path    | JSON         | Poster/flyer images                   |
| status        | TINYINT      | Active/inactive                       |
| created_at    | TIMESTAMP    | Creation timestamp                    |

---

### 9. **subscriptions**
Newsletter subscribers.

| Column         | Type             | Description                      |
|----------------|------------------|----------------------------------|
| id             | INT (PK)         | Subscriber ID                    |
| email          | VARCHAR(255)     | Subscriber email                 |
| subscribed_at  | TIMESTAMP        | When they subscribed             |

---

### 10. **business_categories**
Categories for business listings (e.g., Restaurants, Hospitals).

| Column    | Type           | Description                    |
|-----------|----------------|--------------------------------|
| id        | INT (PK)       | ID                             |
| name      | VARCHAR        | Category name                  |
| status    | TINYINT        | Active/inactive                |

---

### 11. **business_listings**
List of businesses added by users.

| Column       | Type         | Description                           |
|--------------|--------------|---------------------------------------|
| id           | INT (PK)     | Business ID                           |
| user_id      | INT (FK)     | Owner (user)                          |
| category_id  | INT (FK)     | Business category                     |
| business_name| VARCHAR      | Name                                  |
| description  | TEXT         | Info about the business               |
| phone        | VARCHAR      | Contact                               |
| email        | VARCHAR      | Email                                 |
| website      | VARCHAR      | Website                               |
| location_id  | INT (FK)     | Location                              |
| logo_path    | JSON         | Logo image                            |
| status       | TINYINT      | 1=active, 0=inactive                   |
| created_at   | TIMESTAMP    | Creation time                         |

---

### 12. **classifieds**
User-posted job/business classifieds.

| Column        | Type         | Description                        |
|---------------|--------------|------------------------------------|
| id            | INT (PK)     | Classified ID                      |
| user_id       | INT (FK)     | Poster (user)                      |
| type          | ENUM         | 'Job' or 'Business'                |
| title         | VARCHAR      | Title                              |
| description   | TEXT         | Details                            |
| location_id   | INT (FK)     | Location                           |
| contact_email | VARCHAR      | Contact                            |
| contact_phone | VARCHAR      | Contact                            |
| status        | TINYINT      | 1=active, 0=inactive                |
| created_at    | TIMESTAMP    | Post creation                      |

---

### 13. **admin_centers**
Admin users assigned to specific locations.

| Column        | Type         | Description                     |
|---------------|--------------|---------------------------------|
| id            | INT (PK)     | ID                              |
| location_id   | INT (FK)     | Area of responsibility          |
| admin_user_id | INT (FK)     | Assigned admin                  |
| status        | TINYINT      | 1 = active, 0 = inactive         |
| created_at    | TIMESTAMP    | Created on                      |

---

### 14. **post_categories**
Categories for blog or news posts.

| Column      | Type         | Description                       |
|-------------|--------------|-----------------------------------|
| id          | INT (PK)     | Category ID                       |
| name        | VARCHAR      | Name                              |
| description | TEXT         | About the category                |
| status      | TINYINT      | Active/inactive                   |

---

### 15. **posts**
For blogging, announcements, or news.

| Column       | Type         | Description                                |
|--------------|--------------|--------------------------------------------|
| id           | INT (PK)     | Post ID                                    |
| title        | VARCHAR      | Title                                      |
| slug         | VARCHAR      | SEO-friendly unique identifier             |
| content      | TEXT         | Full content                               |
| excerpt      | TEXT         | Short preview (for homepage etc)           |
| category_id  | INT (FK)     | Post category                              |
| author_id    | INT (FK)     | Author (user)                              |
| image        | JSON         | Feature image (original + thumbnail)       |
| is_published | TINYINT      | 1 = visible to public                      |
| published_at | DATETIME     | When published                             |
| created_at   | TIMESTAMP    | Drafted or created                         |

---

### 16. **post_tags**
Tags (like hashtags) for categorizing posts.

| Column   | Type     | Description                 |
|----------|----------|-----------------------------|
| id       | INT (PK) | Tag ID                      |
| post_id  | INT (FK) | Associated blog/news post   |
| tag      | VARCHAR  | A tag like 'culture', 'tech'|

---

## ✅ Additional Notes

- All `status` fields = `1` for active, `0` for inactive.
- All `image` and `file_path` fields use `JSON` to store:
  ```json
  {
    "original": "url_to_original.jpg",
    "thumb": "url_to_thumb.jpg"
  }
  ```
- Designed to be **modular, clean, and scalable**.
