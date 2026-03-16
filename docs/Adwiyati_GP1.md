Princess Sumaya University for Technology

King Hussein School for Computing Sciences

**Adwiyati  
All your medication needs**

**Prepared By:**

Zain Alameen 20220240  
Saif Abbas 20220285

Shahed Alhalabi 20221053

**Supervised By:**

Dr. Samer Sawalha

Project Submitted in partial fulfillment for the degree of Bachelor of Science in Computer Science

First Semester-2025

Declaration of Originality

We, the undersigned, hereby declare that this document has been entirely written and prepared by the project team members listed below.

All materials, ideas, or text taken from external sources have been clearly acknowledged and properly cited in accordance with academic and ethical standards. Every quotation, illustration, image, table, or figure that is not our original work is accompanied by a complete and accurate reference indicating its source.  
We further affirm that this project is the result of our own effort, research, and development, and has not been submitted, in whole or in part, for any other course, degree, or institution.

  
We fully understand that any instance of plagiarism, data fabrication, or misrepresentation constitutes a violation of the academic integrity policy of Princess Sumaya University for Technology (PSUT) and may result in disciplinary action as per the university’s regulations.

Names and Signatures of team members:

|     |     |     |     |
| --- | --- | --- | --- |
| Student Name | University ID | Signature | Date |
| Zain Alameen | 20220240 | \___\___\___\___\___\____ | \___ / \___ / 2025 |
| Saif Abbas | 20220285 | \___\___\___\___\___\____ | \___ / \___ / 2025 |
| Shahed Alhalabi | 20221053 | \___\___\___\___\___\____ | \___ / \___ / 2025 |

Acknowledgments

We wish to express our appreciation to the Princess Sumaya University of Technology (PSUT) and the **King Hussein School of Computing Sciences** for providing us with the resources, facilities, and academic environment to accomplish this project.

We would like to express our gratitude to our supervisor, **Dr. Samer Sawalha**, who has provided guidance, feedback, and motivation during the development of this project. His knowledge helped us overcome obstacles and achieve goals.

We also want to thank **Dr. Ammar Odeh,** who offered great insights on the system design. Moreover, we appreciate the support of all faculty members for their help and support.

And finally, we deeply thank our families and friends who have always supported us. Their constant support was the key motivation that inspired us to excel.

Summary

The existing healthcare management in Jordan is a patchwork of disjointed solutions that fail to meet patients' medication needs. Current solutions, such as My Hakeem, are more focused on the institutional record keeping, and other international systems, such as MediSafe, do not support the Arabic language and local Jordanian pharmaceutical databases. As a result, patients, particularly those with chronic diseases, often have problems with language barriers, misinterpretations, and a lack of professional support.

In order to fill these crucial gaps, this project focuses on the development of **Adwiyati**, an AI pharmaceutical companion system. Adwiyati enhances medication adherence, prevents dangerous drug interactions, and enhances overall healthcare access to Jordanian people. Adwiyati enables users to safely and effectively manage their medications by offering them localized and real-time decision support.

The basis of the system is an object-oriented design to help make the system modular, scalable, and simple to maintain. The system structure consists of a mobile client (Android/iOS) and a server-side backend combined with Supabase and an LLM model for reasoning. To guarantee data security and user protection, the architecture includes a strong user authentication system and a special safety layer of the AI response; this safeguard prevents the system from providing replies that do not meet a certain level of confidence and only replies with reliable medical advice.

The need for such a solution was supported by an analysis stage, involving a survey of 580 participants. The results showed that the project’s core features were highly accepted, in particular, there was a high level of demand in AI side-effect analysis, digital inventory of at-home medication, and smart dose reminders.

Finally, Adwiyati will provide a single patient-centered digital health assistant that is more than just a record-keeping tool and offers a logical and coherent digital health timeline. The project will enhance personal patient safety and create a baseline for academic and technical advancements in developing healthcare systems by localizing modern AI technologies to the Jordanian market. Future improvements like family notifications, such as alerting relatives that a patient has forgotten to take their medication, or that the medication is expiring soon, and direct pharmacy integration so that people can make in-app purchases, and a voice assistant that will allow hands-free medications logging, which will greatly enhance accessibility for elderly and chronically ill users.

List of Abbreviations

**AI:** Artificial Intelligence.

**API:** Application Programming Interface.

**BCR:** Barcode Recognition.

**EHR:** Electronic Health Record.

**ER:** Entity Relationship.

**ERD:** Entity Relationship Diagram.

**JD:** Jordanian Dinar.

**JFDA:** Jordan Food and Drug Administration.

**JSON:** JavaScript Object Notation.

**JWT:** JSON Web Token.

**LLM:** Large Language Model.

**NLP:** Natural Language Processing.

**OS:** Operating System.

**OTC:** Over-The-Counter.

**PDF:** Portable Document Format.

**RAG:** Retrieval-Augmented Generation.

**UI:** User Interface.

**UML:** Unified Modeling Language.

**UX:** User Experience.

**VPS:** Virtual Private Server.

Table of Contents

[Chapter 1: Introduction 11](#_Toc218559529)

[1.1 Overview 11](#_Toc218559530)

[1.1.1 Project Background 11](#_Toc218559531)

[1.1.2 Motivation 11](#_Toc218559532)

[1.1.3 Project Significance 12](#_Toc218559533)

[1.2 Problem Statement 13](#_Toc218559534)

[1.3 Related Work 14](#_Toc218559535)

[1.3.1 Comparative Summary 16](#_Toc218559536)

[1.4 Document Outline 18](#_Toc218559537)

[Chapter 2: Project Plan 19](#_Toc218559538)

[2.1 Project Deliverables 19](#_Toc218559539)

[2.2 Project Tasks 20](#_Toc218559540)

[2.3 Roles and Responsibilities 26](#_Toc218559541)

[2.4 Risk Assessment 27](#_Toc218559542)

[2.5 Cost Estimation 28](#_Toc218559543)

[2.6 Project Management Tools 29](#_Toc218559544)

[Chapter 3: Requirements Specification 30](#_Toc218559545)

[3.1 Stakeholders 30](#_Toc218559546)

[3.2 Platform Requirements 31](#_Toc218559547)

[3.2.1 Client-Side Requirements 31](#_Toc218559548)

[3.2.2 Server-side Requirements 31](#_Toc218559549)

[3.3 Functional Requirements 32](#_Toc218559550)

[3.4 Non-Functional Requirements 35](#_Toc218559551)

[3.5 Other Requirements 36](#_Toc218559552)

[Chapter 4 System Design 37](#_Toc218559553)

[4.1 Logical Model Design 37](#_Toc218559554)

[4.1.1 Architecture Overview 38](#_Toc218559555)

[4.1.2 Required UML Diagrams (Object-Oriented) 39](#_Toc218559556)

[4.1.2.1 Class Diagram 40](#_Toc218559557)

[4.1.2.2 Object Diagrams 41](#_Toc218559558)

[4.1.2.3 Use Case Diagrams 44](#_Toc218559559)

[4.1.2.4 Activity Diagrams 52](#_Toc218559560)

[4.1.2.5 Sequence Diagrams 66](#_Toc218559561)

[4.1.2.6 State Transition Diagrams 69](#_Toc218559562)

[4.1.3 Data Design – ERD & Database Schema 72](#_Toc218559563)

[4.1.4 User Interface Design & Navigation 76](#_Toc218559564)

[4.2 Physical Model Design 94](#_Toc218559565)

[4.2.1 Reports Design 94](#_Toc218559566)

[4.2.2 Physical User Interface Design 94](#_Toc218559567)

[4.2.3 Database Design (3NF) 95](#_Toc218559568)

**Table of Figures**

[Figure 1: Age Group Percentage 21](#_Toc218559569)

[Figure 2: Targeted Users’ Percentage 21](#_Toc218559570)

[Figure 3: Issue of Forgetting Medication Percentage 22](#_Toc218559571)

[Figure 4: Medication Tracker Suggestion Percentage 22](#_Toc218559572)

[Figure 5: Cabinet Medication Feature Suggestion Percentage 23](#_Toc218559573)

[Figure 6: AI assistant Feature Suggestion Percentage 23](#_Toc218559574)

[Figure 7: Adwiyati Gantt Chart 25](#_Toc218559575)

[Figure 8: Adwiyati Architecture Overview 38](#_Toc218559576)

[Figure 9: Class Diagram 40](#_Toc218559577)

[Figure 10: Object Diagram - User Profile 41](#_Toc218559578)

[Figure 11: Object Diagram - Active Treatment 42](#_Toc218559579)

[Figure 12: Object Diagram - Cabinet Medication 43](#_Toc218559580)

[Figure 13: Sign Up Use Case Diagram 44](#_Toc218559581)

[Figure 14: Log In Use Case Diagram 46](#_Toc218559582)

[Figure 15: Medication Management Use Case Diagram 48](#_Toc218559583)

[Figure 16: Chatbot Use Case Diagram 50](#_Toc218559584)

[Figure 17: Sign Up Activity Diagram High Level 52](#_Toc218559585)

[Figure 18: Sign Up Activity Diagram with swim-lanes 53](#_Toc218559586)

[Figure 19: Log In Activity Diagram High Level 54](#_Toc218559587)

[Figure 20: Log In Activity Diagram with swim lanes 55](#_Toc218559588)

[Figure 21: Add New Treatment Activity High Level 56](#_Toc218559589)

[Figure 22: Add New Treatment Activity Diagram with swim lanes 57](#_Toc218559590)

[Figure 23: Add New Cabinet Med Activity Diagram 58](#_Toc218559591)

[Figure 24: Edit Treatment Activity High Level 59](#_Toc218559592)

[Figure 25: Edit Treatment Activity Diagram with swim lanes 60](#_Toc218559593)

[Figure 26: Expiry Monitoring Activity Diagram 61](#_Toc218559594)

[Figure 27: Quantity Monitoring Activity Diagram 62](#_Toc218559595)

[Figure 28: Process Dose Reminder Activity Diagram High Level 63](#_Toc218559596)

[Figure 29: Process Dose Reminder Activity Diagram with swim lanes 64](#_Toc218559597)

[Figure 30: Turn CabinetMed into Active Treatment Activity Diagram 65](#_Toc218559598)

[Figure 31: Sign Up Sequence Diagram 66](#_Toc218559599)

[Figure 32: Log In Sequence Diagram 67](#_Toc218559600)

[Figure 33: Chatbot Sequence Diagram 68](#_Toc218559601)

[Figure 34: Drug Inquiry Sequence Diagram 68](#_Toc218559602)

[Figure 35: Report Generation Sequence Diagram 69](#_Toc218559603)

[Figure 36: Log In State Diagram 69](#_Toc218559604)

[Figure 37: Dose Reminders State Diagram 70](#_Toc218559605)

[Figure 38: Medication State Diagram 70](#_Toc218559606)

[Figure 39: CabinetMed Expiry State Diagram 71](#_Toc218559607)

[Figure 40: Active Treatment Expiry State Diagram 71](#_Toc218559608)

[Figure 41: ER Diagram 72](#_Toc218559609)

[Figure 42: Site Tree Diagram 78](#_Toc218559610)

[Figure 43: English and Arabic Welcome Screens 79](#_Toc218559611)

[Figure 44: Sign Up 80](#_Toc218559612)

[Figure 45: Authentication 80](#_Toc218559613)

[Figure 46: Medical Information 81](#_Toc218559614)

[Figure 47: Personal Information 81](#_Toc218559615)

[Figure 48: Log In 82](#_Toc218559616)

[Figure 49: Forgot Password 82](#_Toc218559617)

[Figure 50: Reset Password 82](#_Toc218559618)

[Figure 51: Home Screen 83](#_Toc218559619)

[Figure 52: Refill Reminder 84](#_Toc218559620)

[Figure 53: Expiry Reminder 84](#_Toc218559621)

[Figure 54: AI Health Assistant 85](#_Toc218559622)

[Figure 55: Scan Medication 86](#_Toc218559623)

[Figure 56: Medication Detected 86](#_Toc218559624)

[Figure 57: Active Treatments List 87](#_Toc218559625)

[Figure 58: Active Treatment Details 87](#_Toc218559626)

[Figure 59: Cabinet Med Details 88](#_Toc218559627)

[Figure 60: My Cabinet 88](#_Toc218559628)

[Figure 61: User Profile 89](#_Toc218559629)

[Figure 62: Add Medication Button 90](#_Toc218559630)

[Figure 63: Add to Cabinet 91](#_Toc218559631)

[Figure 64: Adding Treatment Details Part 1 92](#_Toc218559632)

[Figure 65: Adding Treatment Details Part 2 93](#_Toc218559633)

[Figure 66: Database Schema 95](#_Toc218559634)

**Table of Tables**

[Table 1: Problem Statement 13](#_Toc218559635)

[Table 2: Related Work Table 15](#_Toc218559636)

[Table 3: Comparative Summary Table 16](#_Toc218559637)

[Table 4: Document Outline 18](#_Toc218559638)

[Table 5: Project Deliverables 19](#_Toc218559639)

[Table 6: Project Tasks Description 24](#_Toc218559640)

[Table 7: Roles and Responsibilities 26](#_Toc218559641)

[Table 8: Risk Identification for Project Tasks 27](#_Toc218559642)

[Table 9: Project Cost Estimation 28](#_Toc218559643)

[Table 10: Project Management Tools 29](#_Toc218559644)

[Table 11: Stakeholders 30](#_Toc218559645)

[Table 12: Client Requirements 31](#_Toc218559646)

[Table 13: Hardware Server Requirements 31](#_Toc218559647)

[Table 14: Software Server Requirements 32](#_Toc218559648)

[Table 15: Functional Requirements 32](#_Toc218559649)

[Table 16: Non-Functional Requirements 35](#_Toc218559650)

[Table 17: Other Requirements 36](#_Toc218559651)

[Table 18: Architecture Components 39](#_Toc218559652)

[Table 19: Sign Up Use Case 45](#_Toc218559653)

[Table 20: Log In Use Case 47](#_Toc218559654)

[Table 21: Medication Management Use Case 49](#_Toc218559655)

[Table 22: Chatbot Use Case 51](#_Toc218559656)

[Table 23: User_Profile Table 73](#_Toc218559657)

[Table 24: Medication Table 74](#_Toc218559658)

[Table 25: Active_Treatment Table 74](#_Toc218559659)

[Table 26: Dose_Reminder Table 74](#_Toc218559660)

[Table 27: Cabinet_Med Table 75](#_Toc218559661)

[Table 28: Allergies_And_Conditions Table 75](#_Toc218559662)

[Table 29: User_Allergies_and_Conditions Table 75](#_Toc218559663)

[Table 30: Medication_Side_Effects Table 75](#_Toc218559664)

[Table 31: Use Table 75](#_Toc218559665)

[Table 32: Medication_Uses Table 75](#_Toc218559666)

[Table 33: Treatment_Use Table 75](#_Toc218559667)

[Table 34: User Interface Navigation 76](#_Toc218559668)

[Table 35: Report Design 94](#_Toc218559669)

[Table 36: Physical Specifications of the User Interface Design 94](#_Toc218559670)

[Table 37: Data Normalization Proof 96](#_Toc218559671)

# Chapter 1:  
Introduction

## 1.1 Overview

This project seeks to solve an important problem in individual healthcare management by creating an intelligent pharmaceutical companion system named **Adwiyati** based on AI. The system is set to improve patient management, understanding, and interaction with medications in Jordan by offering intelligent support, localized information, and real-time decision support.

The significance of this project is that it aims to reduce the digital gap between current healthcare services and the daily needs of patients, especially patients with chronic conditions or people managing a variety of medications. Adwiyati aims to help people improve medication adherence, avoid harmful drug interactions, and enhance healthcare access.

Adwiyati uses AI and natural language Processing (NLP) to understand user queries and process pharmaceutical data to provide contextual answers and barcode recognition (BCR) to recognize medication packages.

### 1.1.1 Project Background

The fast-paced progress in artificial intelligence, mobile computing, and natural language processing has made the creation of intelligent healthcare systems more than just data storage and simple reminders. Digital health tools are increasingly expected to provide personalized and real-time support that can be tailored to the medical needs and practices of the user.

Even with such technological advancements, the patients in Jordan continued to adopt fragmented methods of medication administration that involved the use of paper-based prescriptions, manual timers, and non-integrated mobile applications. Such solutions do not offer an integrated or smart management experience, particularly with patients who are suffering from chronic illnesses or with those whose treatment involves multiple drugs.

Moreover, issues of language barriers, lack of access to pharmacists during non-working days, and misunderstanding of medication instructions remain the difficulties that influence the safety and efficacy of medication use. Adwiyati uses the latest AI-based technologies to offer a unified and convenient medication management system that fits in the Jordanian healthcare environment.

### 1.1.2 Motivation

The creation of this project was inspired by the fact that there were apparent limitations on the existing healthcare management solutions for patients in Jordan. These solutions could be broadly categorized into three categories. The first is Electronic Health Records (EHR) systems such as My Hakeem, which mainly assist in record keeping and are not concerned with the daily medication management of patients. The second group includes telemedicine systems, including Altibbi and Sina, that offer efficient remote consultations and symptom evaluation, yet do not involve continuous medication monitoring and management features. The third group comprises the international medication management software, such as MediSafe, that provide reminder settings and lack support for the Arabic language, local pharmaceutical databases, and the Jordanian market of medications.

As a result, there are a number of chronic problems that patients in Jordan encounter, such as a lack of awareness of drug interactions, an inability to cope with long-term treatment, and no access to professional advice beyond the clinical environment. To address these issues directly, Adwiyati offers a safe, Arabic-first, and AI-enabled platform, which assists patients during treatment. When the users enter the symptoms or side effects, the system will scan through the medications they registered and will automatically try to find possible interactions, side effects, and conflicts in treatment and provide contextualized recommendations and warnings.

Moreover, medical data of most patients is still distributed among various applications, hardcopy, or in personal memory. Such fragmentation does not allow patients and healthcare providers to create a coherent and consistent understanding of the medical history of the patient. Adwiyati seeks to solve this problem by presenting a single, patient-owned digital health timeline that uses a single platform to arrange medication consumption, patient symptoms, adverse reactions, and adherence information.

### 1.1.3 Project Significance

This project is important because it can influence not only individual patients but also the entire healthcare ecosystem in Jordan positively. Combining drug tracking, barcode scanning, smart reminders, and an AI-based pharmaceutical advice in one platform, Adwiyati helps in enhancing medication safety, adherence, and health awareness.

On an individual level, patients, especially those with long-term illnesses or a combination of prescriptions, will receive better organized treatment management, preventive recognition of possible interactions between drugs, and have a better understanding of what they are taking. Healthcare providers can also use exported digital health timelines at the clinical level to learn more about patient history to enhance the quality of clinical decisions.

Along with its practical importance, this project also has an academic benefit, as it illustrates the localization of modern AI technologies and their application to the problem of healthcare in developing countries.

## 1.2 Problem Statement

This part outlines the issue that the project aims to address in the following Table 1. It also details the anticipated results and specifies the target audience or users who will benefit from the system.

Table 1: Problem Statement

|     |     |
| --- | --- |
| Aspect | Description |
| Problem Statement | Patients may suffer from various symptoms and struggle to identify the causes of these symptoms and decide whether to seek in-person health care.<br><br>Moreover, patients get overwhelmed while trying to adhere to their medication course and incorporate it into their daily routines. Other challenges include experiencing side effects without knowing their origin, as well as the potential for drug interactions, which may lead to life-threatening conditions. Lastly, most patients have several medications left unused at home without awareness of their proper use.<br><br>Existing medical-related apps provide a limited number of features and don't consider the medications available at the user's home, whereas our system is an all-in-one personalized app. |
| Expected Outcomes | A mobile application powered by an AI chatbot that guides patients during their medical journey. Starting from the moment the user experiences symptoms, up until finishing their medication course. This system will allow users to provide their symptoms to the AI chatbot and get feedback about their condition. It can also be used to further explain information about specific medications. Additionally, the tool helps with managing one's medications by providing reminders, tracking adherence to the medications and possible side effects, and checking drug interactions. |
| Target Audience | The system targets any Jordanian individual wishing to keep track of their medication needs. It mainly benefits patients, especially the elderly, who are struggling with chronic diseases or taking multiple medications simultaneously. But our app is also useful in various other scenarios, including patients who are experiencing symptoms and are unsure of what action to take next, or individuals who only wish to look up and inquire about a medication via only scanning it, and lastly, people who are interested in keeping track of all their at-home medications in one place. |

## 1.3 Related Work

Digital drug management systems are numerous, and so are mobile health systems, as each has a different area of healthcare management. The three major systems are considered here and compared with Adwiyati in relation to how our system is a continuation of them, and how it is different.

As several apps are being built to address various issues of the patient care process, the health-tech start-up market is now evolving at a high rate. These apps fall into the following categories: international medication adherence apps, telemedicine and symptom-checking apps, and national Electronic Health Record (EHR) platforms.

Adwiyati is a feature-rich, AI-powered health companion for Jordan that combines these various features into one friendly interface. In order to shed light as to how exactly Adwiyati is unique, we will compare it to top-rated applications that provide the same functions, specifically, My Hakeem (National EHR), Altibbi/Sina (Regional Telehealth), and MediSafe (International Medication Management).

Table 2 Provides a review and comparison of these three apps, including what each application does, their strengths, and weaknesses.

Table 2: Related Work Table

<div class="joplin-table-wrapper"><table><tbody><tr><td><p>System</p></td><td><p>Description</p></td><td><p>Strengths</p></td><td><p>Limitations/Gaps</p></td></tr><tr><td><p>My Hakeem</p></td><td><p>A Jordanian e-health application developed by Electronic Health Solutions in collaboration with the Ministry of Health and Royal Medical Services. It serves as a bridge between pharmacies, physicians, and patients and enables users to receive and view selective information from their saved electronic health records within healthcare facilities that utilize the Hakeem software. Available on web and mobile platforms, it aims to make healthcare communication, appointment scheduling, and record access easier for citizens of Jordan in a manner where medical information becomes available anytime, anywhere.<sup><a href="#footnote-1" id="footnote-ref-1">[1]</a></sup></p></td><td><ul><li><ul><li>Gives patients access to parts of their EHR.</li><li>Expert in information transfer, access to records, and appointments.</li><li>Tied together under the national Jordanian platform for health.</li><li>Provides a medication home delivery service for chronic disease patients, enabling online refill requests, secure payments, and doorstep delivery.</li></ul></li></ul></td><td><ul><li><ul><li>Participation institutions are commonly associated with integration, and this may restrict coverage.</li><li>A passive repository, filled with healthcare providers (Provider-Centric). Adwiyati, on the other hand, is a user-centric active assistant that is filled in by the user.</li></ul></li></ul></td></tr><tr><td><p>Altibbi / Sina</p></td><td><p>One of the most prominent digital health ecosystems in the Arab world consists of Altibbi and its companion application, Sina. Altibbi offers verified medical data and telehealth with the possibility of online communication with qualified specialists. Sina complements that with AI-based symptom check and smart health tips; thus, both applications tend to cover all the grounds in regard to health-related information in the Arabic language. Altibbi and Sina are partners that focus on connecting patients and physicians and introduce digital-first healthcare solutions to the Arab world.<sup><a href="#footnote-2" id="footnote-ref-2">[2]</a></sup></p></td><td><ul><li><ul><li>Offers AI-driven symptom checking and virtual consultations.</li><li>Matches certified doctors with patients for live consultations.</li><li>Focuses on Arabic accessibility, education, and health awareness.</li><li>Integrates AI features (Sina) for personalized health analysis.</li><li>Has that institutional focus, which is important for trust.</li></ul></li></ul></td><td><ul><li><ul><li>Does not deeply manage medications.</li><li>Must ensure clinician credentials verification and safe triage.</li><li>While Altibbi may result in a prescription, its engagement largely ends there.</li><li>Doctors on the platform cannot issue prescriptions or order lab tests through virtual consultations unless local regulations explicitly permit it for the specific situation.</li></ul></li></ul></td></tr><tr><td><p>Medisafe</p></td><td><p>MediSafe is essentially a medication reminder and management application available worldwide that was developed to increase medication adherence and patient safety. In essence, you are able to follow medications, receive Due-dose and Refill notifications, and even share the information with caregivers or physicians. In addition to that, it records health measurements and makes appointments. Overall, its purpose is to empower both us students and patients with the help of digital technology to track meds and health.<sup><a href="#footnote-3" id="footnote-ref-3">[3]</a></sup></p></td><td><ul><li><ul><li>Reminds patients to take doses, refill prescriptions, and take medication.</li><li>Allows the sharing of adherence data with physicians or caregivers, which is convenient to keep everyone informed.</li><li>Tracks health measurements (blood pressure, glucose, etc).</li><li>Simple, user-friendly interface with a focus on taking medication.</li></ul></li></ul><p></p></td><td><ul><li><ul><li>Its drug interactions database and the medic lookup function are largely US (FDA) or European market-oriented, and therefore, global users may reach an impasse.</li><li>It is highly medicine-oriented and lacks in certain aspects of the patient experience, such as side effects or symptoms monitoring.</li></ul></li></ul><p></p></td></tr></tbody></table></div>

### 1.3.1 Comparative Summary

Table 3 Compares the core features of Adwiyati against the features of other applications in the categories provided below:

Table 3: Comparative Summary Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| Feature | MediSafe | My Hakeem | Altibbi / Sina | Adwiyati |
| Medication Tracking | ✓   |     | ✓   | ✓   |
| Drug Package Scanning |     |     |     | ✓   |
| AI Symptom Chatbot Assistant |     |     | ✓   | ✓   |
| Drug Side Effect Identifier |     |     |     | ✓   |
| AI OTC Recommendations |     |     | ✓   | ✓   |
| Digital Cabinet AI Suggestions |     |     |     | ✓   |
| Drug Interaction Identification/Alert | ✓   |     |     | ✓   |
| Gamification/ Engagement Mechanisms | ✓   |     |     | ✓   |
| Arabic Language Support |     | ✓   | ✓   | ✓   |
| Drug Discovery / Inquiry |     |     |     | ✓   |
| Digital Health Timeline | ✓<br><br>_(Medication Log)_ | ✓<br><br>_(Provider-Built EHR)_ | ✓<br><br>_(Consult History)_ | ✓<br><br>_(Medication Log)_ |
| Digital Inventory of User Meds (Digital Cabinet) |     |     |     | ✓   |

**Discussion:**

Each of the features in the comparison table can be explained further, as shown below:

- **Medication Tracking**: The app’s ability to log and track medication intake by setting reminders based on the user’s dosage details for said medication, which in turn monitors the user’s adherence.
- **Drug Package Scanning**: BCR is used to scan the barcode of a specific medication to minimize manual entry.
- **AI Symptom Chatbot Assistant**: Given a collection of symptoms, the system analyzes them, providing preliminary health information and guiding a user through the most appropriate course of action required, including contacting a health professional, where necessary.
- **Drug Side Effect Identifier**: The platform provides a match of reported side effects to the medications that the user is taking and identifies which drugs are most likely to have caused the identified reaction.
- **AI OTC Recommendations:** An intelligent prescription system that will offer suitable over-the-counter drugs on the basis of the symptoms mentioned, the existing health condition of the user, the current medications, known allergies, and chronic diseases.
- **Digital Cabinet AI Suggestions:** Smart inventory analysis, where appropriate medications are suggested in the existing digital cabinet of the user without the need to visit the pharmacy and/or buy a new medication.
- **Drug Interaction Alerts:** The platform will scan through several medications simultaneously, report any potential drug interaction, and alert in the event of contraindication due to allergies or conditions of the user, or even pregnancy.
- **Gamification and Engagement Mechanisms:** This is a list that assists in the engagement and adherence of the user to the medication by use of game-like aspects of streak tracking, points, levels, and progress visualization.
- **Arabic Language Support:** The platform has a complete localized Arabic interface, medical terms, and an Arabic text entry to support Arabic-speaking users.
- **Drug Discovery and immediate medication inquiry:** Enables users to efficiently identify medications, access detailed drug information, and obtain personalized insights aligned with their health profile and existing medication regimen.
- **Digital Health Timeline**: A chronological summary of a user's health history and adherence for ongoing health tracking.
- **Digital Cabinet Management**: The ability to store a virtual pharmacy cabinet with all medications the user currently possesses, their quantities and expiration dates, and a history of their usage, with the system alerting when medications expire.

In conclusion, Adwiyati incorporates all the above into a patient-centered digital health assistant catering specifically to Jordan.

## 1.4 Document Outline

Table 4 Outlines the chapters included in this project, providing a comprehensive overview of the system’s objectives, development strategy, requirements specifications, and architectural design.

Table 4: Document Outline

|     |     |
| --- | --- |
| **Chapter Title** | **Description** |
| **Chapter 1:** Introduction | Offers the general idea of the project and its specifics of the problem, the comparative analysis of the related work, and the information about the target audience. |
| **Chapter 2:** Project Plan | Has detailed description of the flow of the project defining deliverables, tasks, and responsibility of team members. It also includes a risk evaluation, cost evaluation, and list of tools to be used in managing the project. |
| **Chapter 3:** Requirements specifications | Discusses the functional and non-functional requirements in depth, technical perspective and the specifications required in software and hardware and has a formal declaration of project stakeholders. |
| **Chapter 4:** System Design | Provides a comprehensive design of the system components both in high-level and low-level designs. This encompasses system architecture, database structure, and a complete set of UML diagrams (e.g. Use Case, Sequence, Class) to graphically model the system. |

# Chapter 2:  
Project Plan

## 2.1 Project Deliverables

A breakdown of what we’ll deliver, with a short explanation for each item.

Table 5: Project Deliverables

|     |     |     |
| --- | --- | --- |
| **Name** | **Description** | **Format/Notes** |
| **Documentation** | Explains how our system is designed and built, alongside code documentation. | Word document. |
| **Progress Report** | A document detailing the weekly meetings held, with the outcomes of each. | Word document. |
| **Source Code** | The front-end and back-end code for the mobile application. | Stored in Git repository |
| **Executable Files** | Compiled application or scripts ready for deployment. | Executable or containerized format. |
| **Diagrams** | The documentation will include diagrams that describe the system flow, including architecture, use cases, and ER diagrams. | UML Diagrams. |
| **Databases** | These include users and medications databases. | ER Diagram, and SQL. |
| **UI/UX Prototype** | Designs that will illustrate the user interface provided in the documentation. | Figma designs. |
| **Presentation** | A slide deck summarizing the project’s objectives, features, and outcomes. | PPT format. |

## 2.2 Project Tasks

As shown in Table 6 , this project has major phases and deliverables, along with their estimated durations from requirement gathering to final testing and deployment. This can offer a structure to monitor the progress, making every member aware of their responsibilities and dependencies.

The identification of the needs of the users, examination of similar systems, and finalization of the functional scope to be aimed for will all occur during the **Analysis Phase**. The **Design Phase** will entail the creation of the UI/UX for the interfaces, development of the database schema, and development of the system architecture. To ensure that there is regularized synchronization among the team members, the development of the mobile UI/UX front-end, including the chatbot, and that of the API integration/scanning module back-end will all occur simultaneously in the **Implementation Phase**. Finally, the **Testing and Evaluation Phase** will ensure the functionality, correctness, and usability of the application. Subsequently, all results will be accurately documented for submission and presentation, with consistent documentation throughout.

As part of the analysis phase, we conducted a Google survey to better understand the appeal and needs of our target audience. We have distributed this survey and the following figures: Figure 1, Figure 2, Figure 3, Figure 4, Figure 5, Figure 6 show the responses.

As a result, a medication management tool is required. This can be ascertained from the survey responses. It has been observed that most patients are using supplements or medications regularly, as well as forgetting them occasionally. This is a serious area of concern. Features such as medication reminders, home medication monitoring, scanning of medication information, functionality of AI assistants to provide information regarding medication use safely, as well as side effect or interaction notices, were desired by most patients.

On the whole, the research results indicate that the app is highly accepted and perceived as useful, which proves its critical characteristics, and it complies with the real user requirements, especially in terms of better organization of medications, medication safety, and adherence.

Figure : Age Group Percentage

Figure : Targeted Users’ Percentage

Figure : Issue of Forgetting Medication Percentage

Figure : Medication Tracker Suggestion Percentage

Figure : Cabinet Medication Feature Suggestion Percentage

Figure : AI assistant Feature Suggestion Percentage

Table 6: Project Tasks Description

|     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- |
| **Task ID** | **Task Name** | **Description** | **Dependencies** | **Start Date** | **Due Date** | **Completed** |
| **Analysis** |     |     |     |     |     |     |
| **T1** | Startup Meeting | Meet with the supervisor to discuss and finalize the Adwiyati project idea. | \-  | 14/10/2025 | 20/10 | 100% |
| **T2** | Problem Definition & Research | Define the problem statement and objectives. Collect information about existing solutions and competitors (Altibbi, MediSafe, My Hakeem). | T1  | 20/10 | 27/10 | 100% |
| **T3** | Project Management Plan | Define deliverables, risk assessment, cost estimation, roles, and management tools. | T2  | 27/10 | 3/11 | 100% |
| **T4** | Requirement Gathering | Collect functional and non-functional requirements (features, AI modules, and constraints). | T3  | 3/11 | 10/11 | 100% |
| **Design** |     |     |     |     |     |     |
| **T5** | System Design Documentation | Prepare documentation covering the proposed architecture, workflow, and diagrams. Define how each module (chatbot, scanner, reminders, etc.) interacts. | T4  | 10/11 | 2/1/26 | 70% |
| **T6** | Database Design | Design the database schema to store users’ health data securely, adherence reports, and medications | T4  | 10/11 | 1/1/26 | 100% |
| **T7** | User Interface (UI/UX) Design | Create UI mockups using Figma showing major app flows (chatbot, tracker, scanner). | T4  | 27/10 | 31/12 | 0%  |
| **T8** | Presentation | Prepare presentation slides | T7  | 1/1/26 | 2/1/26 | 0%  |
| **Implementation (Next semester)** |     |     |     |     |     |     |
| **T9** | Implementation (Coding Phase) | Develop frontend, backend, and AI integration using chosen technologies. | T8  | TBD | TBD | 0%  |
| **T10** | Testing & Debugging | Conduct functional, performance, and user testing to ensure stability and usability. | T9  | TBD | TBD | 0%  |

Error! Reference source not found. presents the project’s Gantt chart, illustrating the duration of each task. While specific tasks run simultaneously, others rely on the completion of earlier steps. The timeline is a very close approximation of the tasks that took place.

Figure : Adwiyati Gantt Chart

## 2.3 Roles and Responsibilities

Every team member has a unique role in the project, each contributing to particular tasks. The table below outlines the responsibilities of each individual and their main contributions.

Table 7: Roles and Responsibilities

|     |     |     |
| --- | --- | --- |
| **Team Member** | **Role** | **Responsibilities** |
| Zain Alameen | Team Member | Documentation<br><br>Database<br><br>Diagrams |
| Shahed Halabi | Team Member | Documentation<br><br>Diagrams<br><br>UI/UX designs |
| Saif Abbas | Team Member | Documentation<br><br>Database<br><br>Diagrams |

## 2.4 Risk Assessment

This section identifies potential risks associated with the project tasks, evaluates their likelihood and potential impact, and outlines how the team plans to mitigate or respond to them, all summarized in Table 8. The risks are monitored continuously throughout the project lifecycle to ensure timely resolution.

Table 8: Risk Identification for Project Tasks

| **Risk Description** | **Probability** | **Impact** | **Response / Mitigation Strategy** |
| --- | --- | --- | --- |
| Delay in approval because the supervisor's expectations were misunderstood. | Low | Low | Arrange a kickoff meeting with an overview of the project vision, then follow up through weekly meetings. |
| Lack of credible data sources or an incomplete picture of the healthcare problems in Jordan. | Medium | Medium | Refer to reliable data sources (e.g., Jordan Ministry of Health, WHO, Altibbi). Validate research results with the supervisor. |
| False time estimation or role assignment can lead to confusion in development. | Medium | High | Use project management tools to define roles, responsibilities, and deadlines. Reassess the plan weekly. |
| Missing or conflicting requirements for AI modules, chatbot logic, or scanning features. | High | High | Constant requirements reviews resolve conflicts so the system components integrate seamlessly. |
| Unclear architecture can create integration problems in the future. | Medium | High | Create the architecture diagram at an early stage.<br><br>Get the supervisor’s approval on the diagram.<br><br>Make the design modular for flexibility. |
| Data modeling or relationship errors can become security or privacy risks (Breach of sensitive user health data). | Medium | Medium | Make sure the database is normalized and encrypted. Strict database rules to ensure a user can access only their own data. |
| Incomplete documentation or unclear features. | Low | Medium | Divide responsibilities among team members. |
| Technical errors or delays. | High | High | Use GitHub for version control.<br><br>Scheduled code reviews to reduce errors. |
| Limited testing time or missed functional errors, especially in AI and BCR components. | Medium | High | Test-first development.<br><br>Use real-world test cases, simulate user interactions, and perform regression testing. |
| An inaccurate AI symptom checker provides incorrect or dangerous medical guidance. | High | High | Implement a clear, unmissable disclaimer that the chatbot is "not a medical diagnosis" and to "consult a doctor." Implement a confidence score for AI results and only show suggestions above a certain threshold. |
| The BCR/Scanning feature has low accuracy with different packaging. | High | Medium | Use a high-quality commercial API (e.g., Google Cloud Vision) instead of building a new model. Always require the user to manually confirm the scanned medication data. |
| Scope creep from adding too many complex features are added at once. | Medium | Medium | Strictly adhere to a finalized feature list for the project. All new feature ideas will be logged in a "Future Work" section in the documentation of the second graduation project, but will not be implemented. |
| API Vendor Dependency will result in system failure during service provider downtime or API service interruptions | High | High | Implement a failure logic within edge functions. If GPT-5.2 is not responsive, the backend automatically redirects queries and checks to Gemini 3 flash. |
| The AI might ignore the RAG (Jordanian drug database) and hallucinate answers or provide answers from its training data. | Medium | Medium | Use strict prompts such that the AI only uses the provided context. |
| Data privacy concerns when sending data to third-party APIs. | Low | Medium | Ensure personal information like names and emails is not included in the prompt enrichment process. |
| The backend flow may cause some latency due to the multiple stages that data goes through. | High | Low | Stream responses so data appears as it is generated. Use a cache for frequent queries to avoid DB lookups. |

## 2.5 Cost Estimation

The following table, Table 9, is a breakdown of the estimated cost of external services required for our project.

Table : Project Cost Estimation

|     |     |     |     |
| --- | --- | --- | --- |
| **Category** | **Item** | **Estimated Cost (JD)** | **Notes** |
| **Artificial Intelligence** | GPT-5.2 API Usage | ~180 - 250 | Based on ~$1.75 per 1M input tokens and ~$14.00 per 1M output tokens. |
| **Database and storage** | Supabase | ~0  | Free tier: 500MB DB, 1GB storage |
| **Reporting** | PDFMonkey Pro | ~130 | ~$15/month for up to 3,000 documents. |
| **Mobile app deployment** | Apple Developer Account | ~75 | Required for iOS App Store. |
| Google Play Developer Account | ~20 (one-time) | Lifetime access. |
| **Hosting & API** | Backend VPS (16GB) | ~170 | Standard 16GB RAM instance for Edge Functions and orchestration. |
| Domain Name | ~15 (one-time) | For the backend API. |
| **Contingency & Overages** | API Cost Overages | ~120 | Buffer for unexpected costs. |
| Emergency Fixes | ~120 | Bug fixes, urgent issues. |

**Total Estimated Cost:** Approximately **830–900 JD per year**, including all recurring and one-time expenses.  
_(Note: These calculations are every year unless stated as one-time fees.)_

## 2.6 Project Management Tools

This section lists all tools used in the process of managing our project, shown below in Table 10.

Table 10: Project Management Tools

|     |     |
| --- | --- |
| **Name** | **Description** |
| **Microsoft Word** | Editing the documentation collaboratively. |
| **Google Docs / Drive** | File sharing |
| **ClickUp** | To plan project phases, assign tasks, and track progress. |
| **Figma** | Design user interface. |
| **Google Meet** | Communication and collaboration platform. |
| **Draw.io** | Designing the ER diagram and site map collaboratively. |
| **Lucidchart** | Designing activity, sequence, use case, state, class, and object diagrams collaboratively. |
| **Instagantt** | To keep track of assigned tasks and to produce the project’s Gantt chart. |

# Chapter 3:  
Requirements Specification

This chapter will describe the stakeholders in Section 3.1, the project requirements in Section 3.2, the software's functional and non-functional requirements in Sections 3.3 and 3.4, and any additional requirements in Section 3.5.

## 3.1 Stakeholders

This section lists the stakeholders who will use our system and their interaction with our system in the following Table 11.

Table 11: Stakeholders

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **ID** | **Stakeholder** | **Description** | **Interaction with the system** | **Importance** |
| **S1** | Primary User (Patient) | Patients managing medications or patients with chronic diseases. | Chat with the AI chatbot. Set and receive medication reminders. Maintain a digital health timeline. | The entire system exists to serve end users' healthcare needs. |
| **S2** | Project Development Team | Responsible for designing, developing, and maintaining the system. | Design and develop all system features. Maintain the application. Manage resources. Monitor AI confidence scores. Ensure data security. | Ensures the platform is easy to use, functional, delivers accurate medication information, and provides intelligent AI responses. |

## 3.2 Platform Requirements

The Adwiyati system consists of two subsystems:

1.  Client Side (Mobile App) in Table 12
2.  Server Side (Backend + Database + API orchestration) in Table 13 and Table 14

### 3.2.1 Client-Side Requirements

PRC5 is separate because even if the OS supports notifications (PRC2), users must explicitly grant permission for reminder functionality.

Table 12: Client Requirements

|     |     |     |     |
| --- | --- | --- | --- |
| **Requirement ID** | **Requirement** | **Description** | **Status** |
| **PRC1** | Mobile Device (Smartphone) | The user device on which the Adwiyati app will run. | Mandatory |
| **PRC2** | Android OS / iOS | Minimum: Android 10+ or iOS 14+ to support secure storage and notification services. | Mandatory |
| **PRC3** | Internet Connection | Required for chatbot queries and syncing data with the backend. | Mandatory |
| **PRC4** | Camera Access | Required for barcode scanning (BCR). | Mandatory |
| **PRC5** | Notification Permissions | Required for medication reminders, missed dose alerts, and refill notifications. | Recommended |

### 3.2.2 Server-side Requirements

Table : Hardware Server Requirements

|     |     |     |     |
| --- | --- | --- | --- |
| **Requirement ID** | **Requirement** | **Description** | **Status** |
| **PRS1** | Operating System | Ubuntu 24.04 LTS | Mandatory |
| **PRS2** | Processor | Intel Xeon Scalable or AMD EPYC (8+ physical cores with AVX-512 support for AI orchestration) | Mandatory |
| **PRS3** | Memory | 16 GB - 32 GB ECC RAM (Minimum for managing multiple concurrent RAG queries and safety layer processing) | Mandatory |
| **PRS4** | Database | PostgreSQL 16+ and pgvector extension | Mandatory |
| **PRS5** | Web Server | Nginx 1.25+ | Mandatory |
| **PRS6** | Internet Connection | 100 Mbps to support real-time GPT-5.2 API calls, RAG lookups, and simultaneous user sessions with acceptable latency | Mandatory |

Table : Software Server Requirements

|     |     |     |     |
| --- | --- | --- | --- |
| **Requirement ID** | **Requirement** | **Description** | **Status** |
| **PRS7** | Backend Service Orchestration | Manages flow, coordinates between the Flutter app, Supabase, and AI models. | Mandatory |
| **PRS8** | Supabase Cloud Infrastructure | Provides authentication, database management, and Row-Level Security (RLS) | Mandatory |
| **PRS9** | PGVector Database | Retrieve embeddings for the local Jordanian drug database | Mandatory |
| **PRS10** | GPT-5.2 API Integration | Processes enriched prompts and generating intelligent pharmaceutical advice based on user context. | Mandatory |
| **PRS11** | AI Policy & Safety Layer | Blocks any reply that fails to meet the minimum confidence threshold. | Mandatory |
| **PRS12** | Prompt Enrichment Module | Retrieves the patient’s health profile (allergies, conditions, current meds) and injects it in query. | Mandatory |

## 3.3 Functional Requirements

To make it easier for the users to understand the services offered and the usability of the system, Table 15 below highlights the functional requirements as well as the important features and functionalities that will help to support the users in doing their tasks. The requirements are very important to be identified not only to the developers but also to all parties involved in the project. Functional requirements are the description of how the system will function in a given situation.

Table 15: Functional Requirements

| **ID** | **Requirement** | **Input** | **Process** | **Output** | **Constraints** | **Priority** |
| --- | --- | --- | --- | --- | --- | --- |
| **FR1** | Sign up | Email, password | Validate input, authentication, and create a user account. | Create health profile | The email must be unique, the password must meet security rules, and a valid confirmation link must be provided. | Essential |
| **FR2** | Create health profile | Personal Information (Full name, gender, birth date), medical information (allergies, chronic diseases, smoking status) | Store and link medical data to the user profile | Home page | User must be authenticated. | Essential |
| **FR3** | View profile |     | Retrieve profile data | Display profile information | User must be logged in | Essential |
| **FR4** | Edit profile | New user information | Update profile fields | Updated profile information | User must be logged in | Essential |
| **FR5** | Authentication | User clicks on the confirmation link. | Supabase service authenticates it | Home page | Valid session token | Essential |
| **FR6** | Log in | Email, password | Input validation, authentication | Home page | User must exist in the database, and the correct credentials must be entered. | Essential |
| **FR7** | Log out |     | Log the user out | Return to the sign-up/log-in page | User must be logged in | Essential |
| **FR8** | Forgot password | Email, new password | Input validation<br><br>authentication, and update the password | Log in page | User must exist in the database, and the password must meet security rules | Essential |
| **FR9** | Medication tracking | Dose status | Log medication, recalculate adherence. | Updated dose status | Must be an active treatment | Essential |
| **FR10** | Medication dose reminders | Schedule (time, dose) | Send notifications | Notification | Must be an active treatment | Essential |
| **FR11** | Refill reminders | Quantity | Monitor user's intake and send reminders once the quantity reaches a certain threshold | Refill notification with options to ignore, dispose, or refill bought | Medication must be an active treatment medication that isn't expired. | Essential |
| **FR12** | Expiry date reminders | Expiry date of a medication | Monitor the expiry date and send reminders once the expiry date is close. | Expiry date notification with options to ignore, dispose, or replacement bought | Medication can be an active treatment or cabinet medication. | Essential |
| **FR13** | Add a new active treatment. | Medication details, dose, and duration from new medication or from existing cabinet medication. | Create and store a new treatment | New treatment details | Master medication exists in the database with input validation | Essential |
| **FR14** | Edit treatment | New treatment data | Update the treatment details | Updated treatment details | Input validation | Essential |
| **FR15** | View treatments |     | Retrieve all treatments | Active and completed treatments |     | Essential |
| **FR23** | Dispose of a treatment | Active treatment | An active treatment will be moved to completed treatments if the medication expired, is empty, or the user manually chose to | Completed treatment |     | Essential |
| **FR17** | Medication interaction warning | New medication name, proceed action or not | Check if the new medication interacts with any active treatments | Interaction alert displayed |     | Essential |
| **FR18** | AI symptom chatbot | User symptoms, current medications, and health profile | AI analyzes symptoms using medical history | Possible causes and guidance |     | Essential |
| **FR19** | AI side effect analysis | User side effects, current medications, and health profile | The AI chatbot determines the medication that is causing side effects. | Identified medication |     | Essential |
| **FR20** | AI OTC Recommendations | User symptoms, current medications, and health profile | The AI chatbot suggests appropriate OTC medications available in Jordan. | Appropriate medication |     | Essential |
| **FR21** | Medication scanning | Image of the Barcode of the medication | The system identifies the medication, allowing the user to inquire about it. | Identified medication-relevant details | Must allow camera access | Essential |
| **FR22** | Add a new digital cabinet medication. | Medication details from new medication or from completed treatments | Create and store new medication in the cabinet. | New medication details | Master medication exists in the database, with input validation. | Essential |
| **FR23** | View digital Cabinet |     | Medications in the user's physical cabinet can be used as a suggestion by the chatbot. | All stored medications |     | Essential |
| **FR24** | Dispose of medication. |     | Dispose of the medication if it’s a cabinet medication, if it's expired, or if it's not refilled. | Medication removed |     | Essential |
| **FR25** | Export timeline | Users' intake history | Generate adherence report | Display the generated PDF link. |     | Recommended |
| **FR26** | Progress tracking | Dose status | Calculate the adherence percentage and update points, levels, or streak. | Updated progress log | Medication must be an active treatment medication. | Recommended |

## 3.4 Non-Functional Requirements

The following Table 16 defines how our system should operate, focusing on quality attributes.

Table 16: Non-Functional Requirements

|     |     |     |
| --- | --- | --- |
| **ID** | **Category** | **Description** |
| **NFR1** | Performance | The system should provide fast responses from the chatbot, effective BCR processing, and smooth navigation without any apparent delay. |
| **NFR2** | Security & Privacy | The transmission and storage of the user’s health data should be encrypted. The system must securely authenticate users, only users should be able to access their own data, and adhere to the Jordanian healthcare data protection and privacy laws. |
| **NFR3** | Reliability | The software should not crash, and must deliver functionalities with no disruptions or lags. |
| **NFR4** | Usability | The application interface should be easy, responsive, and flexible to use and navigate through. |
| **NFR5** | Maintainability | The codebase should be well-structured and well-documented. Updates, bug fixes, and new features are easily done. |
| **NFR6** | Scalability | This system should be scalable to add more users and data without affecting performance. |
| **NFR7** | Compatibility | The application should be compatible with both iOS and Android, work well with phones and tablets of various sizes, and work with different versions of different OS so that it can be accessible to all. |
| **NFR8** | Availability | The system must be highly available so that users can reach their medication schedule, digital health timeline, and chatbot support with minimal disruptions. |
| **NFR9** | Accessibility | The system should be available in Arabic, addressing all skill levels of health literacy and technical expertise, such as elderly and chronically ill patients. |
| **NFR10** | Accuracy | The AI chatbot must offer highly trusted responses. |
| **NFR11** | Portability | The architecture must be simple to deploy and platform-independent. |

## 3.5 Other Requirements

This section includes any requirements shown below in Table 17 not covered above, such as technical constraints, protocols, data formats, or external dependencies.

Table : Other Requirements

|     |     |     |
| --- | --- | --- |
| **Requirement Type** | **Description** | **Example** |
| **API Usage Restrictions** | Only RESTful APIs using JSON format are allowed. | Integration with GPT-5.2 for AI queries and PDFMonkey for medical report generation |
| **Data Transmission Protocol** | All communications must use secure HTTPS/TLS 1.3. | Patients’ data transferred between the backend and Supabase must be encrypted. |
| **Data Storage Format** | Data must be stored in UTF-8 to support Arabic text. | AI response in both Arabic and English. |
| **Compliance** | The system must comply with Jordanian healthcare data protection laws | user consent for data collection, and a mandatory AI Safety Layer that prevents low-confidence medical advice. |
| **AI Processing Logic** | System must support Retrieval-Augmented Generation (RAG) | Jordanian drug information in pgvector to allow GPT-5.2 to access localized medication. |

# Chapter 4  
System Design

## 4.1 Logical Model Design

After conducting an extensive analysis of both functional and non-functional requirements, an object-oriented design strategy has been adopted for the logical modeling of our system. This strategy would enable us to systematically define our system by mapping real-world entities into classes that contain both data and functions. Since an object-oriented approach has been adopted for our system, it would remain modular, scalable, and easy to maintain, and would allow us to make amendments with ease.

The logical model is primarily concerned with identifying the fundamental objects of the system, describing their characteristics and techniques, and identifying useful relationships between objects, such as association, inheritance, and composition. It helps to represent the interactions and dependencies of the system efficiently. UML diagrams, specifically class diagrams, are used to visually represent the objects and connections between them to have a complete and clear understanding of the system architecture. There are other diagrams, like use case and activity diagrams, that are used to enhance the logic model by describing the interaction and activities of usage of the system to make sure that the logic of the system is structured and is as per the needs of the user.

### 4.1.1 Architecture Overview

Adwiyati architecture is based on the use of a Flutter mobile client, which communicates with a Supabase backend based on TypeScript Edge Functions in a secure manner. All components are summarized in Table 18 and illustrated in Figure 8.

Upon opening the app, the “Auth UI” communicates with “Supabase Auth”. The Supabase Auth system handles identities with the use of JWT (JSON Web Tokens) and active sessions, This guarantees that the user can gain access to his/her personal medical information only.

When a user submits a query, the backend performs query enrichment by retrieving the patient’s health profile along with their current medications from the database, and conducts a RAG (Retrieval-Augmented Generation) search via pgvector to include localized Jordanian drug context. The enriched prompt is, in turn, run through the GPT-5.2 model, and the response goes through a special AI Safety Layer to maintain clinical accuracy and high confidence before reaching the user.

Upon a user's request through the export module, the PDF Maker in the Backend gathers the adherence information and forwards it to PDFMonkey. The PDFMonkey creates the document and sends a PDF link back, which is shared through the app to the user.

Finally, the user is also given the ability to make use of the Barcode UI that leverages the Google ML Kit for local scanning of the barcode information. The data is then forwarded to the Backend Edge Functions for a "Drug Lookup" within the Master Medication Domain data in PostgreSQL.

Figure : Adwiyati Architecture Overview

Table : Architecture Components

|     |     |     |     |
| --- | --- | --- | --- |
| **Layer / Component** | **Responsibilities** | **Tech Choices** | **Interfaces** |
| **Client (Mobile App)** | Manages UI/UX, local barcode recognition, dose notifications, and user input validation. | Flutter, Google ML Kit (for local BCR) | HTTPS / JSON via Supabase |
| **Backend** | Orchestrates prompt enrichment, manages the RAG service, enforces the AI Safety Layer, and triggers PDF generation. | Typescript | RESTful API / JSON |
| **Database** | Stores health profiles, medication logs, and vector embeddings for local drugs. | Supabase (PostgreSQL + pgvector) | SQL / PostgREST |
| **External AI & Services** | Answer pharmaceutical queries, generate PDF reports. | GPT-5.2 API, PDFMonkey | REST / HTTPS |

### 4.1.2 Required UML Diagrams (Object-Oriented)

The class diagram below **Figure 9** shows the required classes for our system, along with the attributes and operations needed for it to function. As shown, we have mainly divided the classes into three domains: Master medication, User, and Reminder domains. That choice was taken to allow a clear view of all related classes. Lastly, the highlighted green datatypes are enumerations that will be defined in the implementation phase.

### 4.1.2.1 Class Diagram

**Figure 9: Class Diagram**

### 4.1.2.2 Object Diagrams

For the object diagrams, we have chosen what we think best reflects the relationships between object instances, with the first diagram below, Figure 10: Object Diagram - User ProfileFigure 10 showing an object of type User, along with their Health Profile, Allergies, and chronic conditions. This object diagram displays how, when the user first signs up for our app, a user is created along with a health profile and any subsequent details.

Figure : Object Diagram - User Profile

In addition, we displayed the objects of type active treatment, given four dose reminders, in the object diagram Figure 11 below. The medication “Lipitor” refers to the master medication “Atorvastatin,” which needs to be taken twice daily, with different doses in the morning and the evening, with different statuses for each dose reminder from pending to taken to skipped.

Figure : Object Diagram - Active Treatment

Lastly, we showcased in the following Figure 12 the cabinet medication object called “Panadol”, along with its uses and its master medication “Paracetamol”.

Figure : Object Diagram - Cabinet Medication

### 4.1.2.3 Use Case Diagrams

Use Case Diagrams describe the system's functional requirements, with each use case representing a single functional requirement. It is used by customers, designers, developers, and testers, and could be supported with activity diagrams. We provided four main use case diagrams that cover all main functionalities as perceived by the user, which we called a patient.

**_Sign Up Use Case Diagram_**

Figure : Sign Up Use Case Diagram

**Use Case:** Sign up  
**Actors:** Patient  
**Purpose:** Allow the user to create a new profile  
**Overview (Success Scenario):** Starts when the user opens the app for the first time and presses sign up. The user enters their email and password, then the system validates the input and sends a confirmation link that's used to authenticate the user. After the user clicks on the link, the token is verified, and a session is created; the user will be redirected to the app and must create their health profile and start using the system.  
**Type:** Primary  
**Cross Reference Functions:** FR1, FR2, FR5

**Typical course of action:**

Table : Sign Up Use Case

|     |     |
| --- | --- |
| **Actor Action** | **System Response** |
| 1- This use case begins when the user opens the app and presses sign up. |     |
| 2- User enters their email and password. | 3- System validates the input, and if valid, sends a confirmation link to their email address. |
| 4- User opens the external link. | 5- System checks if the token is valid, creates a session, and redirects the user to create their profile. |
| 6- User enters their personal information and medical record to complete their profile. | 6- System successfully creates a profile, stores the information, and redirects the user to the home page. |

**Alternatives:**

Number 2. Invalid email or password entered, and the error message will be displayed.  
Number 4. Invalid token; the user can request another link.

**_Login Use Case Diagram_**

Figure : Log In Use Case Diagram

**Use Case:** Log in  
**Actors:** Patient  
**Purpose:** Allow the user to access their profile  
**Overview (Success Scenario):** Starts when the user opens the app and presses log in, the user enters their credentials, the system validates the input, and if the user exists in the database, the user will be redirected to the home page.  
**Type:** Primary  
**Cross Reference Functions:** FR3, FR4, FR6, FR7, FR8  
**Typical Course of Events:**

Table : Log In Use Case

|     |     |
| --- | --- |
| **Actor Action** | **System Response** |
| 1- This use case begins when the user opens the app and presses log in. |     |
| 2- User enters their email and password. | 3- System validates the input, and if valid and the user exists in the database, the user will be redirected to the homepage. |
| 4- The user is now able to edit or view their profile. |     |

**Alternatives:**

Number 2. Invalid email or password entered; an error message will be displayed.

Number 2. Email doesn't exist in the database; an error message will be displayed.

  

**_Medication Management Use Case Diagram_**

Figure : Medication Management Use Case Diagram

**Use Case:** Medications management  
**Actors:** Patient  
**Purpose:** Allow the user to manage and track treatments and cabinet medications.  
**Overview (Success Scenario):** Starts when the user adds a new medication that could either be an active treatment or stored in the cabinet, then chooses to specify its info manually or by scanning. The user could then view, edit, dispose of the medications, and get reminders to log doses, refill a medication, or replace an expired medication, and track adherence.  
**Type:** Primary  
**Cross Reference Functions:** FR9, FR10, FR11, FR12, FR13, FR14, FR15, FR16, FR17, FR21, FR22, FR23, FR25, FR26

**Typical course of action:**

Table : Medication Management Use Case

|     |     |
| --- | --- |
| **Actor Action** | **System Response** |
| 1- This use case begins when the user presses on the "+" to add a new medication to the cabinet or treatment | 2- System prompts the user to scan the medication's barcode or enter the medication info manually. |
| 3- User specifies the information based on whether the medication is for treatment or the cabinet. | 4- System stores the added medication and redirects medication details. |
|     | 5- System sends reminders about dose intake, refill status, or expired medications. |
| 6- User can log their medication intake. | 7- System updates the intake status and progress report. |
| 8-User presses on treatments or the cabinet | 9- System displays all active and completed treatments or medications stored in the cabinet. |
| 10-User presses on a specific medication | 11- System displays all details of this medication and lets the user edit the info. |
| 12- User updates a specific detail about the medication. | 13- System updates all new information accordingly. |
| 14-User disposes of a certain medication. | 15- System deletes the medication completely. |

**Alternatives:**

Number 4. if the user is adding a treatment and the medication interacts with another current active treatment, the system shows a drug interaction alert with two options to cancel or proceed anyway.

Number 14. If the medication is an active treatment, then it will be moved to completed treatments.

**_Chatbot Use Case Diagram_**

Figure : Chatbot Use Case Diagram

**Use Case:** AI Chatbot  
**Actors:** Patient, Chatbot  
**Purpose:** Allow users to ask specific medical questions and get personalized responses.  
**Overview (Success Scenario):** Starts when the user sends a prompt to the chatbot, asking about either a symptom, a side effect, or some medication; the medical specialized chatbot will answer based on the given prompt and the user's health information.  
**Type:** Primary  
**Cross Reference Functions:** FR18, FR19, FR20

**Typical course of action:**  

Table : Chatbot Use Case

|     |     |
| --- | --- |
| **Actor Action** | **System Response** |
| 1- This use case begins when the user sends a prompt to the chatbot. |     |
| 2- User asks about symptoms that he's been experiencing. | 3- Chatbot responds with possible causes, guidance for dealing with the symptoms, or recommends a medication that the user has in their cabinet. |
| 4- User asks about a side effect. | 5- Chatbot identifies which treatment is causing the side effect. |
| 6-User asks about a specific medication. | 7- Chatbot explains all the needed information and uses of that medication |

### 4.1.2.4 Activity Diagrams

For the activity diagrams, we opted for two approaches for most of the diagrams, by designing a low-level activity diagram for the activities that needed an extra detailed description of where the activities take place, pushing us to use the swim-lane UML notation.

**User Sign Up and Profile Creation high-level activity diagram**

The following Figure 17 diagram showcases the signing up of the user to the system by clicking the “sign up” option when they first open the app. The user then enters their details, after which the system checks the validity of said details. After successful entry, the user is sent a confirmation link to their email that redirects the user to the “profile creation” page, which then saves all details in the database.

Figure : Sign Up Activity Diagram High Level

**User Sign Up and Profile Creation swim-lane activity diagram**

Figure : Sign Up Activity Diagram with swim-lanes

**User Login activity diagram**

Next, we have the login activity in the following Figure 19 that shows the user logging into the app by clicking on the “sign-in” option, which, in turn, takes in the user’s credentials and checks them against the Supabase Authorizing Service, which, upon successful authentication, redirects the user to the main screen.

Figure : Log In Activity Diagram High Level

**User Login activity diagram swim-lane activity diagram**

Figure : Log In Activity Diagram with swim lanes

**Adding a new treatment high-level activity diagram**

In the following diagram Figure 21, the activity of adding a new active treatment by the user is showcased, whether by manual entry or through scanning the drug package. If the drug causes any interactions with any current active treatments, the user is warned. The system checks the validity of the input details and requires the user to enter any dose reminder details for the course of the treatment.

Figure : Add New Treatment Activity High Level

**Adding a new treatment swim-lane activity diagram**

Figure : Add New Treatment Activity Diagram with swim lanes

**Adding a new cabinet medication high-level activity diagram**

Similarly, the following diagram Figure 23 showcases the addition of any new cabinet medications through scanning or manual entry, but has no interaction warnings since the user is not actively taking the medication.

Figure : Add New Cabinet Med Activity Diagram

**Edit treatment high-level activity diagram**

To follow the addition of any active treatments, the following diagram Figure 24 displays the editing of any active treatments, whether by stopping the treatment as a whole, cancelling any edit operation, or even changing specific dosage amounts and/or frequencies. The system follows the user’s actions by validating any input and clearing any prescheduled dose reminders to start scheduling new ones based on the latest updates. Lastly, since in our app we don’t dispose of any active treatment, we only update its status to completed. If any remaining quantity is left in the treatment, the system logs it as one of the user’s cabinet medications.

Figure : Edit Treatment Activity High Level

**Edit treatment swim-lane activity diagram**

Figure : Edit Treatment Activity Diagram with swim lanes

**Expiry date monitoring swim-lane activity diagram**

The activity of monitoring any expired or expiring medications of any type (active or cabinet), is displayed in the following diagram Figure 26. It starts with a daily scheduler that checks the expiry dates of all the user's medications and constantly reminds the user to buy replacements. In the case that the user kept ignoring those reminders, the system automatically disposes of them or archives them into his/her completed treatments. If the user buys a refill, the quantity and expiry date of the medication are updated.

Figure : Expiry Monitoring Activity Diagram

**Treatment quantity monitoring swim-lane activity diagram**

In a similar fashion, the quantity of an active treatment is monitored, but is triggered only upon the user’s intake of the medication by pressing the “take” button on the dose reminder notification. That is shown in the following diagram Figure 27.

Figure : Quantity Monitoring Activity Diagram

**Process medication reminder high-level activity diagram**

The core activity of our app is modeled in the following activity diagram Figure 28 , whereby the dose reminders are only scheduled and queued one reminder at a time for efficiency purposes. Whenever a certain reminder is due, the notification is pushed to the user, and he/she either skip or take their dose. Upon entry of their dose reminder details, the user is given the choice of entering a specific end date for the treatment, to take a specific number of pills, or neither. Based on the user’s initial choice, the next reminder is calculated accordingly.

Figure : Process Dose Reminder Activity Diagram High Level

**Process medication reminder swim-lane activity diagram**

Figure : Process Dose Reminder Activity Diagram with swim lanes

**Turn cabinet medication into active treatment high-level activity diagram**

Lastly, the following activity diagram Figure 30 models the user’s choice of starting taking any cabinet medication in his possession, and that could be due to the recommendation of the chatbot that takes into account any existing cabinet medications when recommending medications based on symptoms. It essentially follows the same path as adding an active treatment.

Figure : Turn CabinetMed into Active Treatment Activity Diagram

### Sequence Diagrams

**_Sign up Sequence Diagram_**

Figure 31 represents the sign-up process when the user first opens the app. After entering the email and password, the system verifies the user's input. If it's valid, then the Supabase authorization service will send a confirmation link to the user, then create a session if it's a valid token, meaning the link hasn't expired, and no errors have occurred, and lastly, the user will be redirected to create their health profile and store it securely in the database.

Figure : Sign Up Sequence Diagram

**_Log In Sequence Diagram_**

Figure 32 represents the login process. After entering the email and password, the system checks the validity of the user's input. If it's valid, then we need to check if the credentials entered are correct and exist in Supabase. If so, a session will be created, and the user will be redirected to create their homepage.

Figure : Log In Sequence Diagram

**_Chatbot Sequence Diagram_**

Conversing with the chatbot is a process shown in the following Figure 33 that keeps going until the user stops sending prompts. To ensure the user gets a personalized response, for every prompt, the system will decide its medical context, and retrieve any related information from the database, then finally, provide it to the AI model within what we call an enriched prompt.

Figure : Chatbot Sequence Diagram

**_Drug Inquiry Sequence Diagram_**

One important functionality in Adwiyati is the ability to scan any medication, and the system will identify it, as shown in Figure 34. The system also allows us to ask more questions about the medication by asking our AI assistant. The scanning process uses a BCR scanner to convert the barcode in the image into a string. We can then use this string to retrieve its information from our database.

Figure : Drug Inquiry Sequence Diagram

**_Report generation Sequence Diagram_**

The report generation process is shown in Figure 35. The adherence report contains information about the user’s dose status during a period of time. We first retrieve the needed information from the database, then use an external PDF generator service to generate the report.

Figure : Report Generation Sequence Diagram

  

### State Transition Diagrams

**_Log in State Transition Diagram_**

Figure 36 is a simple representation of the users' states related to logging in. The user starts as logged out if the app is opened for the first time, then the user can enter credentials, and if they're correct, the user is considered logged in and can proceed to use Adwiyati.

Figure : Log In State Diagram

**_Dose reminders State Transition Diagram_**

A dose reminder for an active treatment can be in four main states illustrated in Figure 37. It starts as a scheduled reminder, and when its date is reached, we consider the reminder as a due reminder. The user can then either log their dose intake or not log any intake, so the reminder is considered to be missed.

Figure : Dose Reminders State Diagram

**_Treatment and Cabinet medication State Transition Diagram_**

An important state transition diagram is shown in Figure 38. This diagram represents all possible states of a used medication (that is, the medication isn't disposed of). If a new treatment is added, we name it an “Active treatment.” Active treatments remain active as long as the medication isn't empty (quantity > 0) and the treatment duration is still ongoing. However, if the duration of the treatment has ended, we move it to the “Completed treatment” section. This section can also be triggered if the user decides to stop the treatment or if the quantity of the medication ends. A “Cabinet medication” describes medications that aren't empty, but are no longer taken as a treatment, and or just in the possession of the user.

Figure : Medication State Diagram

**_Cabinet Medication Expiry Date State Transition Diagram_**

Since we must always monitor the expiry date of a medication and remind the user if the medication is about to expire, we alert the user as long as the expiry date hasn't been reached. If the user doesn't buy a replacement before the expiry date, then the medication is disposed of. The user can also choose to dispose of the medication before it reaches the expiry date. Figure 39 illustrates the states for a Cabinet medication.

Figure : CabinetMed Expiry State Diagram

**_Active Treatment Medication State Transition Diagram_**

The process of monitoring the expiry date for a medication that's currently being taken as an Active treatment doesn't differ much from a Cabinet medication, as shown in Figure 40, except that disposing of a medication will move it to the completed treatment section instead of deleting it completely. This is done to make sure the treatment is included in the adherence report.

Figure : Active Treatment Expiry State Diagram

### 4.1.3 Data Design – ERD & Database Schema

Figure : ER Diagram

As shown above in Figure 41**,** our entity relationship diagram describes the nature of our database from the user profile to all types of medication. In our medication entity, we ensured we stored only the relevant attributes to share with the user when showcasing the treatment details, not anything more, since the AI model will handle analyzing extra details, such as active ingredients, that could result in drug interactions. The medication attributes were chosen to align with the JFDA’s approved drug list<sup>[\[4\]](#footnote-4)</sup> available on the official Jordanian Gate website, to ease implementation in the upcoming semester.

The following tables are on the next two pages: Table 23, Table 24, Table 25, Table 26, Table 27, Table 28, Table 29, Table 30, Table 31, Table 32, Table 33 describes the detailed schema from columns and types to notes and constraints, with each table detailing the corresponding table in our database.

Table : User_Profile Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| user_id | UUID | PK, FK → auth.users(id) | No  | ON DELETE CASCADE |
| first_name | VARCHAR(100) |     | No  |     |
| last_name | VARCHAR(100) |     | No  |     |
| dob | DATE |     | No  |     |
| gender | VARCHAR(10) |     | No  | CHECK IN ('Male','Female') |
| blood_type | VARCHAR(3) |     | Yes | CHECK IN ('A+','A-','B+','B-','O+','O-','AB+','AB-') |
| weight_kg | NUMERIC(5,2) |     | Yes |     |
| smoker | BOOLEAN |     | Yes | DEFAULT FALSE |
| pregnant | BOOLEAN |     | Yes | Allowed only if gender = Female |
| total_points | INT |     | Yes | DEFAULT 0 |
| current_streak | INT |     | Yes | DEFAULT 0 |
| longest_streak | INT |     | Yes | DEFAULT 0 |
| last_action_date | TIMESTAMP |     | Yes |     |
| level | INT |     | Yes | DEFAULT 1 |
| created_at | TIMESTAMP |     | No  | DEFAULT NOW() |
| updated_at | TIMESTAMP |     | No  | DEFAULT NOW() |

Table : Medication Table

| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| --- | --- | --- | --- | --- |
| medication_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| --- | --- | --- | --- | --- |
| dosage_form | VARCHAR(30) |     | No  | CHECK valid dosage forms |
| --- | --- | --- | --- | --- |
| trade_name_en | TEXT |     | No  |     |
| --- | --- | --- | --- | --- |
| trade_name_ar | TEXT |     | No  |     |
| --- | --- | --- | --- | --- |
| scientific_name_en | VARCHAR(255) |     | No  |     |
| --- | --- | --- | --- | --- |
| scientific_name_ar | VARCHAR(255) |     | No  |     |
| --- | --- | --- | --- | --- |
| dose_instructions | TEXT |     | Yes |     |
| --- | --- | --- | --- | --- |
| other_instructions | TEXT |     | Yes |     |
| --- | --- | --- | --- | --- |
| storage_instructions | TEXT |     | Yes |     |
| --- | --- | --- | --- | --- |
| barcode | VARCHAR(255) |     | Yes | UNIQUE |
| --- | --- | --- | --- | --- |
| original_quantity | NUMERIC(6,2) |     | No  | CHECK > 0 |
| --- | --- | --- | --- | --- |
| dose_amount | NUMERIC(6,2) |     | No  |     |
| --- | --- | --- | --- | --- |
| unit | VARCHAR(30) |     | Yes | CHECK valid units |
| --- | --- | --- | --- | --- |

Table : Active_Treatment Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| treatment_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| user_id | UUID | FK → user_profile.user_id | No  | ON DELETE CASCADE |
| medication_id | UUID | FK → medication.medication_id | No  |     |
| start_date | TIMESTAMP |     | No  |     |
| end_date | TIMESTAMP |     | Yes | Must be > start_date |
| times_per_day | INT |     | No  | DEFAULT 1, > 0 |
| interval_days | INT |     | No  | DEFAULT 1, > 0 |
| current_quantity | NUMERIC(6,2) |     | No  |     |
| pills_taken_so_far | INT |     | Yes | DEFAULT 0 |
| pills_to_take | INT |     | Yes |     |
| expiry_date | DATE |     | No  |     |
| status | VARCHAR(15) |     | No  | CHECK IN ('active','completed') |

Table : Dose_Reminder Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| reminder_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| treatment_id | UUID | FK → active_treatment.treatment_id | No  | ON DELETE CASCADE |
| planned_date | DATE |     | No  |     |
| planned_time | TIME |     | No  |     |
| actual_time | TIME |     | Yes |     |
| quantity_to_take | NUMERIC(5,2) |     | No  |     |
| status | VARCHAR(15) |     | No  | CHECK IN ('pending','taken','skipped') |

Note: if the user does not log in (take action on the reminder) the system automatically logs it as skipped.

Table : Cabinet_Med Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| cabinet_med_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| user_id | UUID | FK → user_profile.user_id | No  | ON DELETE CASCADE |
| medication_id | UUID | FK → medication.medication_id | No  |     |
| quantity | NUMERIC(6,2) |     | No  |     |
| expiration_date | DATE |     | No  |     |
| exp_alert_sent | BOOLEAN |     | Yes | DEFAULT FALSE |

Table : Allergies_And_Conditions Table

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Column** | **Type** |     | **PK/FK** | **Nullable** | **Notes / Constraints** |
| allergy_condition_id | UUID |     | PK  | No  | DEFAULT gen_random_uuid() |
| type | VARCHAR(20) |     |     | No  | CHECK IN ('Allergy','Condition') |
| name | TEXT |     |     | No  |     |

Table : User_Allergies_and_Conditions Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| user_id | UUID | PK, FK → user_profile.user_id | No  | ON DELETE CASCADE |
| allergy_condition_id | UUID | PK, FK → allergies_and_conditions.allergy_condition_id | No  |     |

Table : Medication_Side_Effects Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| side_effect_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| medication_id | UUID | FK → medication.medication_id | No  | ON DELETE CASCADE |
| side_effect | TEXT |     | No  |     |

Table : Use Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| use_id | UUID | PK  | No  | DEFAULT gen_random_uuid() |
| name | TEXT |     | No  |     |

Table : Medication_Uses Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| medication_id | UUID | PK, FK → medication.medication_id | No  | ON DELETE CASCADE |
| use_id | UUID | PK, FK → use.use_id | No  |     |

Table : Treatment_Use Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Column** | **Type** | **PK/FK** | **Nullable** | **Notes / Constraints** |
| treatment_id | UUID | PK, FK → active_treatment.treatment_id | No  | ON DELETE CASCADE |
| use_id | UUID | PK, FK → use.use_id | No  |     |

### 4.1.4 User Interface Design & Navigation

The Adwiyati app user interface is designed to be simple, clean, usable, and user-friendly to ensure meeting UX design requirements. To apply accessibility practices, five core screens share the same bottom navigation bar, enabling intuitive navigation between them. As well as a top navigation bar that includes the profile icon on the left, and a (+) button on the right that allows adding new medications either to the cabinet or as an active treatment. These core screens include Home screen, Chatbot, Medication Scan, Treatments, and Cabinet. It's crucial to note that the interface supports bilingual use (Arabic and English) to ensure usability for all target users. The following Table 34 summarizes the flow of each screen.

Table : User Interface Navigation

| **Screen** | **Purpose** | **Key Elements** | **Navigates To** |
| --- | --- | --- | --- |
| Welcome | Entry point to the application | App logo, Login, Sign Up buttons | Login, Sign Up |
| Sign up | Create a new user account | Email, Password, Confirm Password | Verification |
| Login | Authenticate existing users | Instruction message, Resend email | Verification |
| Authentication | Email confirmation via Supabase | Email, Password, Forgot Password | Home screen, or Personal Information, or Reset Password |
| Forgot password | Authenticate user to allow password reset | Email | Reset password |
| Reset password | Updating password | New Password, Confirm New Password | Login |
| Personal info | Specifying Personal information | First Name, Last Name, Gender, Date of Birth | Medical Record |
| Medical Record | Specifying medical history details | Blood Type, Allergies, Chronic Diseases, Weight, Smoking Status. | Home screen |
| Home | Daily overview of medication intake | Calendar, To Take list, Progress Log |     |
| Chatbot | Conversation with AI chatbot | Chat interface |     |
| Scan | Scan medication barcodes | Camera view, action options | Add Treatment, Add Cabinet Medication, Chatbot |
| Treatments | View and manage treatments | Active/Completed lists of treatments | Treatment Details |
| Cabinet | View stored medications | Medication list | Cabinet Medication Details |
| Profile | Manage personal and medical data | Personal info, Medical record, Reports |     |
| Add New Medication – Step 1 | Select how medication is added | Scan medication, Enter manually, | Medication Info, Scan |
| Add New Medication – Step 2 | Capture basic medication information | Medication name, Form, Dose amount, Dose unit | Quantity & Expiry |
| Add New Medication – Step 3 | Define storage related details | Quantity, Expiration date | Cabinet (if cabinet med) / Treatment Setup |
| Add New Medication – Step 4 (Treatment Only) | Define treatment and reminder details | Purpose of use, End date, Dose reminders (time, days, quantity) | Treatments |
| Cabinet Medication Details | View details of a stored medication | Medication name, Form, Dose amount & unit, Quantity, Expiration date, Add to Treatment button, Delete medication | Add to Treatment |
| Treatment Details | View treatment specific medication information | Medication name, Form, Dose amount & unit, Start date, End date, Dose Reminders, Add to Cabinet button, End Treatment button | Add to Cabinet |

The following Figure 42 is a site tree diagram that explains the flow between the main screens. It's important to note that the user can at any moment switch between the 5 core screens through the bottom navigation bar and access their profile or add new medications through the top navigation bar.

Figure : Site Tree Diagram

**_Welcome screen_**

Figure 43 represents the entry point when the user first downloads the system. The user can then choose to either create a new account by signing up or logging in with an existing account. Moreover, the user can switch between the Arabic or English language and choose whatever they're comfortable with.

Figure : English and Arabic Welcome Screens

**_Sign up and Authentication_**

Figure 44 represents the sign-up page, where the user will enter their email and password. The system will check the validity of the input, and if it is valid, proceed to authenticate the user.

Figure 45 alerts the user that a confirmation link has been sent to their email address to verify their identity. This screen is displayed in two cases: signing up and forgetting the password. If the user did not receive the email or the link expired, the screen allows them to simply regenerate a new one by pressing the resend button.

Figure : Sign Up

Figure : Authentication

**_Health profile creation_**

After Authentication through a confirmation link, the user is redirected to Figure 47 to enter their personal information. To complete the creation of a Health Profile, a medical record page is displayed to register the needed medical information, including selecting chronic diseases or allergies from a drop-down list, as shown in Figure 46.

Figure : Medical Information

Figure : Personal Information

**_Login and Reset Password_**

If the user chooses to log in within the welcome page, then Figure 48 is displayed. After entering the correct credentials, the user is redirected to the home page. Otherwise, an error message will be displayed, and the login process will fail. The screen shows a “Forgot password?” option for users who want to reset their password. Figure 49 is shown in that case, then Figure 45 must alert the user of the confirmation link as discussed previously. Upon successful verification, the user can reset their password via Figure 50, then return to log in with the new credentials.

Figure : Log In

Figure : Forgot Password

Figure : Reset Password

**_Home Screen and Progress Log_**

The first core screen is the Home screen in Figure 51, which presents a calendar view, then a “To Take” section that displays the dose reminders for this day where the user can log their intake status, and a “Progress Log” section that shows the adherence percentage, number of pills taken and scheduled, and the current day streak of 100% adherence. Pressing the progress log section navigates to another screen that includes the gamification features of the application, such as points, levels, and the longest streak.

Figure : Home Screen

**_Reminders_**

Figure 53 and Figure 52 are examples of two reminders, one for the expiry date and the other for refills. The user can choose to ignore the reminder, dispose of the medication, or log that a new medication has been bought.

Figure : Refill Reminder

Figure : Expiry Reminder

**_AI Health Assistant_**

Figure 54 displays an example of a conversation with the Adwiyati AI Health Assistant, where the user can ask about symptoms, side effects, certain medications, and get a personalized response. This is the second core screen in the application.

Figure : AI Health Assistant

**_Scan Medication_**

The third core screen is the Scan Medication, as shown in Figure 55. The user must scan the barcode of the medication; the system then identifies the medication that shows in Figure 56, three options are displayed: either adding the medication as a new active treatment, which navigates to Figure 64 and Figure 65 as will be discussed. The second option is to add the medication to the digital cabinet, which then displays Figure 63. Lastly, the user can simply ask more questions about this medication and will be redirected to the chatbot.

Figure : Scan Medication

Figure : Medication Detected

**_Treatments_**

Figure 57Figure 57 is the fourth core screen, which is the Treatments display. Treatment could either be active or completed. Pressing on a treatment shows its details, as in Figure 58. The user can then choose to edit the treatment or stop taking it, which moves it to the completed treatments section, and finally, move the medication for this treatment to the digital cabinet.

Figure : Active Treatments List

Figure : Active Treatment Details

**_Cabinet_**

The fifth and last core screen is the Cabinet screen, which displays all current medications stored in the user's digital cabinet, which then can be used by the AI assistant as suggestions. Each medication detail can be viewed, edited, or deleted. Additionally, the user can simply start to take this medication as a new active treatment. These are showcased in Figure 60, and Figure 59**.**

Figure : Cabinet Med Details

Figure : My Cabinet

**Profile**

The profile screen in Figure 61 is divided into 3 main sections. The first section is the personal information, the second section displays all medical-related information, and lastly, the reports section, which allows the user to select a range of months, and the system will then generate a PDF progress report that shows the adherence of the user's active treatments within the chosen date range. This screen also allows the user to log out of the system and redirects them to the welcome page.

Figure : User Profile

**_Add New Treatment_**

Pressing the (+) button in the top navigation bar displays two options for adding a new medication, as shown in Figure 62, either to the cabinet or as a new active treatment. Both processes include the same 3 main steps. However, adding a treatment will require a fourth step.

Figure : Add Medication Button

The first step in adding a new medication is to choose how to enter the medication information, that is, either manually or by scanning. If the user chooses to scan, then they will be redirected to the scan medication screen. A second step is needed if the user chooses to enter the details manually, but it is also displayed after scanning to allow the user to verify and edit the details if needed. Then the cabinet medication information must be completed by adding the expiry date and quantity during step 3. The new cabinet medication process is displayed through Figure 63.

Figure : Add to Cabinet

In the case that the user chose to add a new treatment, then before moving to the third step, the system must check for any drug interactions that this medication might cause with any of the current active treatment medications and alert the user. If no drug interactions were found or the user chose to proceed anyway, the user must complete step 3. Then a fourth step is required to specify important information, including the purpose of use, end date, and dose reminders. It's important to mention that details, including medication name and purpose, are chosen from a dropdown list. All illustrated in Figure 64 and in Figure 65 in the following page.

Figure : Adding Treatment Details Part 1

Figure : Adding Treatment Details Part 2

## 4.2 Physical Model Design

In this section, the physical design is presented. This is the implementation design that takes the logical design to implementable parts, such as finalized user interface design, report design, as well as the design of the normalized database in the Third Normal Form.

### 4.2.1 Reports Design

The following Table 35 describes the design of our adherence report, which the user can export on demand.

Table : Report Design

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Report Name** | **Audience** | **Inputs/Filters** | **Layout Fields (Order)** | **Format** |
| Adherence Report | Users (Patient) | Date range (specific months) | Columns will represent the days of the month; each row will contain a certain dose reminder. Each cell will be marked as either taken, skipped, or scheduled. | PDF |

### 4.2.2 Physical User Interface Design

As listed below in Table 36, the technical details of the styles and components used in our interface are broken down.

Table : Physical Specifications of the User Interface Design

|     |     |     |     |
| --- | --- | --- | --- |
| **Token/Component** | **Spec** | **Accessibility** | **Notes** |
| Primary Color | Blue #2563EB | Contrast ≥ 4.5:1 | Main actions, buttons, highlights |
| Secondary Color | Teal #14B8A6 | Contrast ≥ 4.5:1 | Accent color |
| Background Color | Light gray #F9FAFB | Low glare |     |
| Font Stack | Inter, Arial, sans-serif | Resizable text | Default size 14-16 pt |
| Heading | Inter Bold 18–24pt | Clear hierarchy |     |
| Primary Button | Filled and rounded | Focus ring | Main actions |
| Form Inputs | Labels, hints, error text, rounded, and outlined. |     | Must validate input |
| Bottom navigation | 5 items, middle is center and popped out |     | Must exist across all core screens |
| Top navigation | 1 item to the left (profile), 1 to the right (+) |     | Must exist across all core screens |

### 4.2.3 Database Design (3NF)

Lastly, the following Figure 66 is a diagram showing our database schema. This database schema is normalized to 3NF. The proof is shown in Table 37, in the next page. All tables have atomic attributes, full functional dependency, and no transitive dependency. All derived data or aggregated data are handled in the application layer. This ensures the integrity of data can be scalable and maintainable.

Figure : Database Schema

Table : Data Normalization Proof

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **Table** | **1NF** | **2NF** | **3NF** | **Notes / Proof** |
| user_profile | All attributes are atomic (e.g., first_name, dob, weight_kg) | Single-column PK (user_id); all attributes fully depend on it | No non-key attribute depends on another non-key attribute | Authentication data separated in auth.users; gamification fields derived only from user actions |
| medication | Atomic attributes (dosage_form, unit, quantities) | Single-column PK (medication_id); no partial dependencies | No transitive dependencies; descriptive attributes depend only on medication_id | Uses and side effects separated into junction tables |
| active_treatment | Atomic scheduling and quantity fields | Single-column PK (treatment_id); attributes depend on treatment | No transitive dependencies between medication or user attributes | User and medication details referenced via FKs |
| dose_reminder | Atomic date/time and quantity fields | Single-column PK (reminder_id) | No transitive dependencies | Status and timestamps depend only on reminder_id |
| cabinet_med | Atomic quantity and expiration values | Single-column PK (cabinet_med_id) | No transitive dependencies | Medication metadata not duplicated |
| allergies_and_conditions | Atomic name and type | Single-column PK (allergy_condition_id) | No transitive dependencies | Lookup table; no derived attributes |
| user_allergy_condition | Atomic FK references | Composite PK ensures full dependency | No transitive dependencies | Pure junction table |
| medication_side_effect | Atomic side_effect field | Single-column PK (side_effect_id) | No transitive dependencies | Side effects separated from medication table |
| use | Atomic description | Single-column PK (use_id) | No transitive dependencies | Lookup table |
| medication_use | Atomic FK references | Composite PK enforces full dependency | No transitive dependencies | Resolves many-to-many relationship |
| treatment_use | Atomic FK references | Composite PK enforces full dependency | No transitive dependencies | Resolves many-to-many relationship |

1.  https://my.hakeem.jo/index.php/en/site/index [↑](#footnote-ref-1)
    
2.  https://altibbi.com/%D8%B9%D9%86-%D8%A7%D9%84%D8%B7%D8%A8%D9%8A [↑](#footnote-ref-2)
    
3.  https://www.medisafe.com [↑](#footnote-ref-3)
    
4.  https://jordan.gov.jo/en/CustomPages/OpenDataItemDetails?hdn=3163&name=General%20Organization%20for%20Food%20and%20Drug [↑](#footnote-ref-4)