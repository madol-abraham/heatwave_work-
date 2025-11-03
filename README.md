# Harara: A Real time Heatwave Prediction System for South Sudan
 **Harara** which means "Heat" in Arabic is an intelligent early warning system that predicts heatwave conditions across 6 major cities in South Sudan.
Using satellite data and machine learning, the system provides 7-day heatwave forecasts and sends SMS alerts to registered users to help communities prepare for extreme heat events.
The system includes real-time monitoring, predictive analytics, and comprehensive dashboard for authorities and researchers.

 **Features**

 **Real-time heatwave prediction** via satellite data and ML model  
 **SMS alerts** using Africa's Talking API  
 **Multi-platform support** - Flutter mobile app, React web dashboard  
 **Interactive dashboard** with charts, and analytics  
 **User registration** and location-based alerts  
 **Historical data** tracking and trend analysis
 **Technical support** For users facing issues with the platform  
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



<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (12)" src="https://github.com/user-attachments/assets/e9c430cb-5d79-453a-a00d-0c04801f2298" />



<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (13)" src="https://github.com/user-attachments/assets/7c159172-5021-4cd9-8a44-f0ef9f01ae24" />


<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (14)" src="https://github.com/user-attachments/assets/0b794f15-5894-49d8-aa2b-ee2788468935" />



<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (15)" src="https://github.com/user-attachments/assets/7a28d671-757c-459d-ac9a-02538cbdc9f3" />



<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (11)" src="https://github.com/user-attachments/assets/fa071383-cdfa-49ca-a571-ac08205af6c6" />

<img width="284" height="574" alt="iPhone-13-PRO-MAX-localhost (16)" src="https://github.com/user-attachments/assets/a89ab934-0923-467d-999b-382fab569ab5" />

<img width="1366" height="768" alt="Screenshot (251)" src="https://github.com/user-attachments/assets/38b4b7f5-f3d9-4273-9853-a654d82d208d" />





<img width="1366" height="768" alt="Screenshot (252)" src="https://github.com/user-attachments/assets/0b5fcf7a-0251-47f8-b7fc-d2cbc6b9807d" />

 


<img width="1366" height="768" alt="Screenshot (253)" src="https://github.com/user-attachments/assets/631a509a-b2a7-4e33-a1b4-5dbc6da0fc8a" />




<img width="1366" height="768" alt="Screenshot (255)" src="https://github.com/user-attachments/assets/4400707f-d2e1-428e-a11b-94a558ba5402" />
<img width="1366" height="768" alt="Screenshot (257)" src="https://github.com/user-attachments/assets/83268bde-bbc1-4792-a2ce-04f218ace16d" />




<img width="1366" height="768" alt="Screenshot (258)" src="https://github.com/user-attachments/assets/2f858ff5-9317-4cb1-92cd-d7967ab2cb0e" />




 
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
- **React**: JavaScript, Chart.js, Tailwind CSS
- **Cloud**: Google Earth Engine, Firebase, Africa's Talking
- **Database**: SQLite, Firestore
- **ML**: Neural networks, time series forecasting

##  Analysis of Results
**Objective Achievement Assessment:**
The Harara system successfully met 100% of the objectives outlined in the original project proposal developed with supervisor guidance. The LSTM model achieved 85% accuracy (exceeding the 80% target), real-time SMS alerts were implemented with 95% delivery success rate, and the multi-platform architecture was fully deployed across Flutter, React, and FastAPI components.

**Performance Metrics vs. Proposal Goals:**
- ✅ **Heatwave Prediction Accuracy**: Achieved 85% (Target: 80%)
- ✅ **SMS Alert Delivery**: 95% success rate (Target: 90%)
- ✅ **Multi-city Coverage**: 6 cities implemented (Target: 6 cities)


 **Discussion of Milestones & Impact**
**Milestone 1 - Data Pipeline Integration (Month 1-2):**
Google Earth Engine integration proved critical for accessing MODIS and ERA5 satellite data. This foundation enabled real-time environmental monitoring across South Sudan's diverse climate zones, directly supporting the supervisor's emphasis on scalable data architecture.

**Milestone 2 - ML Model Development (Month 3-4):**
The LSTM neural network development phase demonstrated the importance of time-series forecasting for climate prediction. Supervisor feedback on model validation techniques improved our ROC-AUC score from 0.85 to 0.931, significantly enhancing prediction reliability.

**Milestone 3 - SMS Alert System**
Africa's Talking API integration expanded system reach to communities without internet access. This milestone had the highest community impact, enabling early warning delivery to vulnerable populations as emphasized in supervisor discussions on social responsibility.

**Milestone 4 - Multi-platform Deployment**
Flutter mobile app and React dashboard completion enabled both community access and administrative oversight. The supervisor's guidance on user experience design proved essential for adoption in low-literacy environments.

**Community Impact Assessment:**
The system's ability to predict heatwaves 7 days in advance provides crucial preparation time for agricultural communities, potentially reducing heat-related health risks and crop losses as identified in supervisor-guided impact analysis.

   **Recommendations**
**For Community Implementation:**
- **Training Programs**: Establish community workshops on system usage and heatwave preparedness
- **Local Partnerships**: Collaborate with NGOs and health centers for wider SMS alert distribution
- **Offline Capabilities**: Deploy system in areas with limited internet through local radio integration
- **Language Localization**: Expand Arabic support and add local dialects for better accessibility

**For Government Agencies:**
- **Policy Integration**: Incorporate Harara alerts into national disaster preparedness protocols
- **Meteorological Collaboration**: Integrate with South Sudan Meteorological Department for enhanced accuracy
- **Funding Support**: Secure sustainable funding for long-term operation and maintenance

**For Technical Deployment:**
- **Infrastructure Requirements**: Ensure reliable internet connectivity in target deployment areas
- **Data Backup**: Implement redundant data storage systems for continuous operation
- **User Support**: Establish help desk services for technical assistance

 **Future Work**
**Phase 1**
 **Integration with meteorological stations** in South Sudan for ground-truth validation
 **Enhanced mobile app** with offline prediction capabilities
 **Voice alert system** for non-literate users via local radio partnerships

**Phase 2**
 **Multi-hazard prediction** expanding to droughts and floods
 **Regional expansion** to neighboring East African countries
 **Advanced analytics** for long-term climate trend analysis

**Phase 3**
 **AI model enhancement** with transformer architectures for improved accuracy
 **Health impact integration** linking heatwave predictions to hospital preparedness
 **Agricultural advisory** system for crop protection recommendations

 
 **Integration with the data from the metrological stations in South Sudan**
 **Add support for more climate events such as drought and flood** 
 **Enhance mobile app** with offline capabilities
 **Add voice alert support** for non-literate users
 **Improve model** with more datasets from metrogical stations
 **Expand coverage** to other towns in the country
 **Advanced analytics** for climate trend analysis

**Owner**
**Madol Abraham Kuol Madol**  
📧 Email: m.madol@alustudent.com
