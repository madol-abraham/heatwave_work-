# Harara: AI Heatwave Prediction System
 **Harara** which means "Heat" in Arabic is an intelligent early warning system that predicts heatwave conditions across South Sudan.
Using satellite data and machine learning, the system provides 7-day heatwave forecasts and sends SMS alerts to registered users to help communities prepare for extreme heat events.
The system includes real-time monitoring, predictive analytics, and comprehensive dashboard for authorities and researchers.

 **Features**
 **Real-time heatwave prediction** via satellite data and ML model  
 **SMS alerts** using Africa's Talking API  
 **Multi-platform support** - Flutter mobile app, React web dashboard  
 **Interactive dashboard** with charts, and analytics  
 **User registration** and location-based alerts  
 **Historical data** tracking and trend analysis  
 **Multi-language support** (English/Arabic)  
 **Cloud integration** with Firebase and Google Earth Engine  
 **Data export** capabilities for research and analysis  

 **Installation & Setup**

## 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/Harara_folder.git
cd Harara_folder
```

## 2️⃣ Backend Setup (Python API)
```bash
cd "Harara Api"
python -m venv harara_env
# Windows
harara_env\Scripts\activate
# Linux/Mac
source harara_env/bin/activate

pip install -r requirements.txt
```

## 3️⃣ Mobile App Setup (Flutter)
```bash
cd "Blue app/heat"
flutter pub get
flutter run
```

## 4️⃣ Dashboard Setup (React)
```bash
cd "Harara Api/dashboard"
npm install
npm start
```

## 5️⃣ Environment Configuration
Create `.env` files in respective directories:

**Backend (.env)**:
```env
EE_SERVICE_KEY=your_google_earth_engine_key
FIREBASE_SERVICE_KEY=your_firebase_service_key
AT_USERNAME=your_africastalking_username
AT_API_KEY=your_africastalking_api_key
```

**Flutter (.env)**:
```env
API_BASE_URL=http://localhost:8000
FIREBASE_API_KEY=your_firebase_api_key
```

 **Don't share your .env files publicly! Use .env.example for version control.**  
 **Add .env to .gitignore**

▶️ **Running the System**

**Start Backend API:**
```bash
cd "Harara Api"
python main.py
# Visit http://localhost:8000/docs
```

**Start Mobile App:**
```bash
cd "Blue app/heat"
flutter run
```

**Start Dashboard:**
```bash
cd "Harara Api/dashboard"
npm start
# Visit http://localhost:3000
```

 **Testing Highlights**
 
 **Accurate heatwave predictions** for 6 South Sudan cities  
 **Real-time SMS alerts** sent to registered users  
 **Interactive maps** showing risk levels and forecasts  
 **Multi-language support** with Arabic localization  
 **Responsive design** across mobile, tablet, and desktop  
 **Firebase integration** for real-time data sync  
 **Google Earth Engine** satellite data processing  
 **Machine learning models** with 85%+ accuracy  

 **Screenshot Highlights**




![ACT](https://github.com/user-attachments/assets/ef90f4ec-af4c-41d2-b96e-33ad0dc42946)

![ACT](https://github.com/user-attachments/assets/0f1fb6a0-b493-4aa3-87a7-f04d58069c29)





<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (3)" src="https://github.com/user-attachments/assets/2b5a96b0-169c-4a01-ac87-2349cdfbbb74" />


<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (4)" src="https://github.com/user-attachments/assets/c2f3f02d-3f17-4cb4-b53f-89def198dbd0" />





<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (9)" src="https://github.com/user-attachments/assets/56f4522e-e05a-41e1-a92a-67ccbd4f0641" />





<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (8)" src="https://github.com/user-attachments/assets/9bb18c3f-64d8-4e63-8ce2-e9bbc68e7a89" />





<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (7)" src="https://github.com/user-attachments/assets/b7a66b86-d505-41cb-8c4b-8f1f3c3ee152" />





<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (6)" src="https://github.com/user-attachments/assets/a4e5345d-3c5d-42d0-a786-bd7d7b419b18" />






<img width="1366" height="768" alt="Screenshot (251)" src="https://github.com/user-attachments/assets/38b4b7f5-f3d9-4273-9853-a654d82d208d" />





<img width="1366" height="768" alt="Screenshot (252)" src="https://github.com/user-attachments/assets/0b5fcf7a-0251-47f8-b7fc-d2cbc6b9807d" />

 


<img width="1366" height="768" alt="Screenshot (253)" src="https://github.com/user-attachments/assets/631a509a-b2a7-4e33-a1b4-5dbc6da0fc8a" />



 
<img width="1366" height="768" alt="Screenshot (254)" src="https://github.com/user-attachments/assets/b320d577-f1ff-4f42-b2ca-47645f21d5bd" />



<img width="1366" height="768" alt="Screenshot (255)" src="https://github.com/user-attachments/assets/7ed3d95c-e41f-4065-b9b2-0e4edfb22bce" />


 **System Architecture**
- **Backend**: FastAPI + SQLite + Firebase + Google Earth Engine
- **Mobile**: Flutter with Firebase integration
- **Dashboard**: React + Chart.js
- **ML Pipeline**: TensorFlow + Scikit-learn
- **Notifications**: Africa's Talking SMS API
- **Data Source**: Google Earth Engine

 **Supported Cities**
- Juba
- Wau
- Malakal  
- Bentiu
- Bor
- Yambio

 **Key Technologies**
- **Python**: FastAPI, TensorFlow, Pandas, NumPy
- **Flutter**: Dart, Firebase, Provider state management
- **React**: JavaScript, Chart.js, Leaflet, Tailwind CSS
- **Cloud**: Google Earth Engine, Firebase, Africa's Talking
- **Database**: SQLite, Firestore
- **ML**: Neural networks, time series forecasting

## Analysis of Results
The system successfully achieved its core objectives of predicting heatwave conditions with high accuracy across South Sudan.
The LSTM model demonstrated strong performance with 85%+ accuracy in distinguishing between heatwave and normal conditions.
SMS alerts were successfully triggered for high-risk predictions, and all activities were stored in Firebase and SQLite.
Overall, the system achieved its goals of heatwave prediction, early warning alerts, and community engagement as outlined in the project proposal.

** Validation Evaluation:**
```
              precision    recall  f1-score   support

 No Heatwave       0.92      0.87      0.89       730
    Heatwave       0.75      0.84      0.79       340

    accuracy                           0.86      1070
   macro avg       0.83      0.85      0.84      1070
weighted avg       0.87      0.86      0.86      1070

ROC-AUC: 0.931
PR-AUC: 0.897
```

** Test Evaluation:**
```
              precision    recall  f1-score   support

 No Heatwave       0.88      0.89      0.89       368
    Heatwave       0.81      0.79      0.80       214

    accuracy                           0.85       582
   macro avg       0.84      0.84      0.84       582
weighted avg       0.85      0.85      0.85       582

ROC-AUC: 0.909
PR-AUC: 0.901
```

 **Discussion of Milestones & Impact**
Each milestone contributed critically to the system's functionality.
Early integration of Google Earth Engine and Firebase allowed us to process satellite data and store real predictions.
Adding Africa's Talking SMS expanded the impact by notifying communities even in remote areas without internet access.
The system's ability to scale across multiple cities shows potential for practical deployment in regions affected by climate change.
Through this project, I learned the importance of satellite data integration, model optimization, and community-centered design in building systems for real-world climate challenges.

 **Future Work**
 **Integration with the data from the metrological stations in South Sudan**
 **Add support for more climate events such as drought and flood** 
 **Enhance mobile app** with offline capabilities
 **Add voice alert support** for non-literate users
 **Improve model** with more diverse satellite datasets
 **Expand coverage** to other East African countries
 **Advanced analytics** for climate trend analysis
