# -📱IoMT-Fitbit-Integration-Stress-Monitoring-App

A Flutter-based mobile application that connects with the Fitbit Web API to retrieve physiological data and supports manual daily stress check-ins. This project demonstrates a practical Internet of Medical Things (IoMT) workflow by combining wearable data, cloud services, and mobile user input in a unified health monitoring system.

⸻

🧾 Overview

This application was developed as part of an academic project to illustrate how mobile applications, wearable devices, and cloud infrastructure can be integrated for basic health monitoring.

The system retrieves heart rate data from the Fitbit API, stores it in AWS DynamoDB, and allows users to log daily stress levels through a simple mobile interface. The project highlights real-world concepts such as API integration, cloud-based processing, and data persistence.

⸻

🚀 Features
    •    Query heart rate data from the Fitbit API
    •    Store heart rate records in AWS DynamoDB
    •    Automatically refresh Fitbit access tokens using OAuth 2.0
    •    Log daily stress levels manually
    •    Store stress check-in data in DynamoDB
    •    Clean and responsive Flutter-based user interface
    •    RESTful communication via AWS API Gateway and Lambda

⸻

🏗️ System Architecture

The system follows a cloud-based IoMT architecture:

Flutter App (Frontend)
        ↓
API Gateway (REST API)
        ↓
AWS Lambda (Backend Logic)
        ↓
Fitbit API + DynamoDB (Data Layer)

Components
    •    Frontend: Flutter mobile application
    •    Backend: AWS Lambda functions
    •    API Layer: AWS API Gateway
    •    Database: AWS DynamoDB
    •    External Service: Fitbit Web API

⸻

📂 Project Structure

final_project/
│
├── frontend/
│   └── fetch_data_demo/
│       ├── lib/
│       │   ├── pages/
│       │   │   ├── home.dart
│       │   │   ├── query_data.dart
│       │   │   ├── save_data.dart
│       │   │   └── stress.dart
│       │   ├── api_functions.dart
│       │   └── main.dart
│       └── pubspec.yaml
│
├── backend/
│   ├── getHeartRate.py
│   ├── saveHeartRate.py
│   ├── saveStress.py
│   └── refreshToken.py
│
└── README.md


⸻

🛠️ Technologies Used
    •    Flutter – Mobile frontend development
    •    AWS Lambda – Serverless backend logic
    •    AWS API Gateway – REST API communication
    •    AWS DynamoDB – NoSQL cloud database
    •    Fitbit Web API – Wearable health data integration
    •    OAuth 2.0 – Secure authentication and token management

⸻

⚙️ Setup Instructions

1. Clone the Repository

git clone https:https://github.com/SyllasO/-IoMT-Fitbit-Integration-Stress-Monitoring-App.git
cd your-repo-name


⸻

2. Run the Flutter App

Ensure Flutter is installed:

flutter doctor

Then run:

cd frontend/fetch_data_demo
flutter pub get
flutter run


⸻

3. Configure AWS Backend

Set up the following AWS resources:

DynamoDB Tables
    •    HeartRate
    •    StressData
    •    fitbitToken

Lambda Functions
    •    getHeartRate
    •    saveHeartRate
    •    saveStress
    •    refreshToken

API Gateway
Create REST endpoints and connect them to the corresponding Lambda functions.

⸻

🔐 Fitbit API Setup

To access Fitbit data:
    1.    Create an application at the Fitbit Developer Portal
    2.    Obtain:
    •    Client ID
    •    Client Secret
    3.    Implement OAuth 2.0 authorization
    4.    Store access and refresh tokens in DynamoDB
    5.    Use the refresh token mechanism to maintain valid sessions

⸻

🧪 Usage

Query Heart Rate
    •    Select a start date and end date
    •    Retrieve heart rate data from Fitbit

Save Heart Rate
    •    Store selected Fitbit data into DynamoDB

Stress Check-In

Users can enter:
    •    Date
    •    Stress score (1–10)
    •    Optional notes

The data is stored in the StressData table.

⸻

📊 Example DynamoDB Record

StressData Table

checkin_date    stress_score    notes    timestamp
2026-04-08    6    Final test    2026-04-08T18:30:00


⸻

⚠️ Notes
    •    This project is intended for academic demonstration purposes
    •    It is not designed for clinical or diagnostic use
    •    Fitbit API access requires valid authentication tokens
    •    AWS services may incur usage costs

⸻

🔮 Future Improvements
    •    Automate Fitbit data synchronization using EventBridge
    •    Add data visualization (charts and trends)
    •    Support multiple users with authentication
    •    Integrate with EHR systems using FHIR APIs
    •    Apply predictive analytics for stress and health monitoring

⸻

👨‍💻 Author

Silas Otutey
MS Health Informatics – Michigan Technological University

⸻

📄 License

This project is for educational use only.

