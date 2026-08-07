# Smart City Reporting System


## 📌 Overview

This full-stack project aims to improve citizen engagement and optimize urban problem management by providing a digital platform for reporting, tracking, and resolving city issues.

Citizens can report problems such as road damage, lighting failures, and waste management issues through a mobile application. The system uses artificial intelligence to automatically analyze submitted reports and classify issues.

---

## ✨ Key Features

- 🔐 Secure authentication with JWT and role-based access control
- 📱 Mobile application for citizens to submit reports
- 📸 AI-powered image analysis for urban issues
- 🤖 Automatic generation of report title, description, and category
- 🏷️ Automatic issue classification such as:
  - Road problems
  - Lighting problems
  - Waste management
- 🔄 Report status management:
  - Pending
  - In Progress
  - Resolved
  - Rejected
- 📊 Admin dashboard for report management

---

# 💻 Technical Stack

## 📱 Mobile Application

- Flutter
- Dart

## 🌐 Admin Dashboard

- React 18
- TypeScript

## ⚙️ Backend

- Spring Boot 4
- Java 17
- Hibernate

## 🤖 AI Integration

- OpenRouter AI API
- NVIDIA: Nemotron 3 Nano Omni model
- OpenAI gpt-oss-20b model

AI capabilities:

- Image understanding
- Automatic report classification
- Report title generation
- Description generation

## 🗄️ Database

- PostgreSQL

## 🔐 Security
-Spring Security
- JWT Authentication
- Role-Based Access Control (RBAC)


---

# 📁 Project Structure

```bash
smart-city-reporting-system/

├── admin-dashboard               
│
├── Backend                
│
├── frontend-mobile              
│   
└── README.md
```

---

# 🚀 Getting Started

## Prerequisites

- Java 17+
- Maven 3.9+
- Flutter SDK
- Node.js 18+
- PostgreSQL

---

# 🔧 Installation

## Clone Repository

```bash
git clone https://github.com/jihenesaad/smart-city-application.git

cd smart-city-application
```
# 🔄 Application Workflow

The application workflow supports two report creation scenarios:

## 📸 Case 1: Report with Image

```
Citizen
   |
   |
Mobile Application
   |
   |
Create Report
(Image + Location)
   |
   |
AI Image Analysis
   |
   |
Generate:
- Title
- Description
- Category
   |
   |
Store Report
   |
   |
Admin Dashboard
   |
   |
Update Report Status
```

---

## 📝 Case 2: Report without Image

```
Citizen
   |
   |
Mobile Application
   |
   |
Create Report
(Title + Description + Location)
   |
   |
AI Text Analysis
   |
   |
Classify problem:
- Category
   |
   |
Store Report
   |
   |
Admin Dashboard
   |
   |
Update Report Status
```
---

