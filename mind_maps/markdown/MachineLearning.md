---
title: Machine Learning
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Machine Learning

## Amazon Rekognition

### Overview

- Image and video analysis using ML.

### Core Features

- Object, scene, and activity detection.
- Facial detection, analysis (gender, age, emotion), comparison, and search.
- Celebrity recognition.
- Text detection in images/videos.
- Pathing analysis (e.g., for sports).
- Image/Video labeling.

### Content Moderation

- Detects inappropriate, unwanted, or offensive content.
- Set minimum confidence thresholds for flagging.
- Integrates with Amazon Augmented AI (A2I) for optional manual review.
- Use Cases: Enhance user safety on social media, broadcast, advertising, e-commerce.

## Amazon Transcribe

### Overview

- Converts speech to text (Automatic Speech Recognition - ASR) using deep learning.

### Features

- High accuracy transcription.
- Automatic language identification for multilingual audio.
- PII (Personally Identifiable Information) Redaction.

### Use Cases

- Transcribe customer service calls.
- Automate closed captioning and subtitling.
- Generate searchable metadata for media assets.

## Amazon Polly

### Overview

- Converts text into lifelike speech using deep learning. Enables applications to talk.

### Features

- Wide range of voices and languages.
- Customization via Pronunciation Lexicons (e.g., for acronyms, specific names).
- SSML (Speech Synthesis Markup Language) support for fine-grained control (emphasis, pauses, whispering, phonetic pronunciation, Newscaster style).

## Amazon Translate

### Overview

- Provides natural and accurate language translation using deep learning.

### Use Cases

- Localize content (websites, applications) for international users.
- Translate large volumes of text efficiently.

## Amazon Lex

### Overview

- Service for building conversational interfaces (chatbots, voice bots) using voice and text. Uses the same deep learning technologies as Alexa (ASR and NLU).

### Features

- Automatic Speech Recognition (ASR) for speech-to-text.
- Natural Language Understanding (NLU) to recognize user intent.

### Integration

- Often used with AWS Lambda for backend logic and Amazon Connect for call center solutions.

## Amazon Connect

### Overview

- Cloud-based virtual contact center service. Easy to set up and manage.

### Features

- Receive calls, create automated contact flows.
- Integrates with other CRM systems and AWS services (like Lex and Lambda).
- Pay-as-you-go pricing, potentially cheaper than traditional solutions.

### Example flow

- Phone call (schedule an appointment) → *call* → Connect → *stream* → Lex (intent recognized) → *invoke* → Lambda → *schedule* → CRM

## Amazon Comprehend

### Overview

- Fully managed Natural Language Processing (NLP) service to extract insights and relationships from text. Serverless.

### Features

- Language detection.
- Entity recognition (people, places, brands, events).
- Key phrase extraction.
- Sentiment analysis (positive/negative/neutral/mixed).
- Syntax analysis (tokenization, parts of speech).
- Topic modeling (group documents by discovered topics).

### Use Cases

- Analyze customer feedback, organize documents, process text for insights.

## Amazon Comprehend Medical

### Overview

- Specialized NLP service for extracting information from unstructured medical text. HIPAA eligible.

### Features

- Detects medical conditions, medications, dosages, Protected Health Information (PHI), etc.
- DetectPHI API for identifying PHI.

### Use Cases

- Analyze physician's notes, discharge summaries, test results, clinical trial reports.

### Integrations

- Analyze documents from S3, real-time streams via Kinesis Data Firehose, output from Amazon Transcribe.

## Amazon SageMaker

### Overview

- Fully managed platform for the entire machine learning lifecycle. Designed for developers and data scientists.

### Capabilities

- Data preparation, building, training, tuning, deploying, managing, and monitoring ML models. Simplifies complex ML workflows.

### Example flow

- Historical data (# years of experience in IT, # years of experience with AWS, …) → *label* with scores → ML Model → *train & fine-tune*
- New data → *apply model* → Prediction (e.g. "PASS WITH 906")

## Amazon Forecast

### Overview

- Fully managed service using ML for highly accurate time-series forecasting.

### Accuracy

- Claims up to 50% more accuracy than traditional methods.

### Process

- Uses historical time-series data and related data (e.g., product features, promotions, web traffic) to train models and generate forecasts.

### Use Cases

- Product demand forecasting, financial planning, resource planning, inventory management.

### Example flow

- Historical time-series data (product features, prices, discounts, …) → *upload* → S3 → Forecast → *produce* → Forecasting Model → future sales

## Amazon Kendra

### Overview

- Highly accurate intelligent enterprise search service powered by ML.

### Features

- Natural language query understanding.
- Extracts specific answers from documents (not just document links).
- Connectors for various data sources (S3, RDS, SharePoint, Salesforce, Google Drive, Websites, etc.).
- Learns from user interactions (Incremental Learning).
- Tunable relevance ranking.

### Example flow

- Data sources (S3, RDS, Google Drive, MS SharePoint, MS OneDrive, 3rd party / custom) → *indexing* → Amazon Kendra ← User asks "Where is the IT support desk?" → answer "1st floor"

## Amazon Personalize

### Overview

- Fully managed ML service for creating real-time personalized recommendations. Uses the same technology as Amazon.com.

### Features

- Delivers personalized product/content recommendations, customized re-ranking, and direct marketing suggestions.
- Easy integration via API into websites, apps, email systems, etc.
- Handles complex ML pipeline automatically (data processing, feature engineering, model training, deployment).

### Use Cases

- Retail (product recommendations), media & entertainment (content suggestions).

### Example flow

- Amazon S3 (*read data from S3*) + Amazon Personalize API (*real-time data integration*) → Amazon Personalize → customized personalized API → Websites & Apps, Mobile Apps, Emails, SMS

## Amazon Textract

### Overview

- Service that automatically extracts text, handwriting, and data from scanned documents using ML.

### Capabilities

- Extracts text from virtually any document (PDFs, images).
- Extracts data from forms (key-value pairs) and tables while preserving structure.

### Use Cases

- Automate data entry from financial documents (invoices, reports), healthcare records (claims), public sector forms (taxes, IDs, passports).
