# Adwiyati — Diagram ↔ Code Checklist

Use this to track alignment between `adwiyati_docs/*.png` (and GP1) and the Flutter app (`lib/`).

**Legend:** `[ ]` not done · `[~]` partial · `[x]` matches diagram / FR intent

---

## Class diagram (`Class_Diagram.png`)

### Domain models (attributes & structure)

- [ ] **ActiveTreatment:** add `threshold` (refill) if required by DB/diagram; keep in sync with `active_treatment` table
- [ ] **ActiveTreatment:** diagram methods (`calculateNextDoseTime`, `registerDoseTaken`, `moveActiveToCabinet`, `checkRefillThreshold`, …) — either implement as domain methods or document “implemented in services”
- [ ] **Medication:** `getSideEffects()` / `getRecommendedDosage()` — or equivalent queries from `medication_side_effects` / DB
- [ ] **User vs HealthProfile:** diagram shows split; code uses merged `UserModel` — OK if documented; otherwise align naming/docs
- [ ] **User** diagram methods: `generateAdherenceReport`, `requestPDF` — wire to export flow when built

### Services (diagram types)

- [ ] **ReminderService:** `scheduleReminder`, `cancelReminder`, `sendReminderNotifications` — centralize vs scattered inserts/updates
- [ ] **AI_Orchestrator:** enrichment, interaction detection, RAG, scan interpretation — backend + client integration

---

## Add new treatment (`Add_New_Treatment_Activity_*.png`)

- [ ] Scan path: after scan, return to wizard with **prefilled** med info and **Edit Med Info** step (diagram: scan → edit → merge)
- [ ] Camera permission handling before scan (explicit UX / permission flow)
- [ ] **Interaction check:** matches FR17 (drug–drug / profile), not only duplicate same `medication_id` active treatment
- [ ] **Set dose reminders:** generate **future** reminders (not only seed for one day)

---

## Add new cabinet med (`Add_New_Cabinet_Med_Activity_Diagram.png`)

- [ ] Scan path: prefilled data + edit step after scan (same as treatment flow)
- [ ] Camera permission + real barcode pipeline (see Phase 5 / `Barcode` UI)

---

## Edit treatment (`Edit_Treatment_Activity_*.png`)

- [ ] On **edit dosage/schedule:** validate input, update treatment, then **regenerate future `dose_reminder` rows** (clear old schedule or update in place)
- [ ] **Stop treatment:** clear/cancel pending reminders (DB + any local notifications)
- [ ] **Stop treatment:** set status **completed**
- [ ] **Stop treatment:** if remaining quantity **> 0**, **create/update `cabinet_med`** (move to cabinet) per diagram

---

## Process dose reminder (`Process_Dose_Reminder_Activity_*.png`)

- [ ] On **taken:** set reminder status + **`actual_time`** (done)
- [ ] On **taken:** **deduct** from `active_treatment.current_quantity` and update **`pills_taken_so_far`** (diagram: deduct quantity)
- [ ] After take/skip: **adherence metrics** (partially via gamification — verify full parity)
- [ ] **Next reminder:** if `(end date not reached AND qty OK) OR pills-to-take target not reached` → **schedule next** `dose_reminder`; else **stop treatment** (diagram condition)
- [ ] **Push / local notification** display path matches “Display reminder notification”

---

## Cabinet → active treatment (`Turn_CabinetMed_into_Active_Treatment_Activity_Diagram.png`)

- [ ] **Start taking** opens flow with **treatment details entry** (reminders, duration, purpose as per product)
- [ ] **Interaction check** before commit (same as add treatment)
- [ ] **Set dose reminders** — not only empty treatment row; align with `createActiveTreatment` behavior

---

## System architecture (`Adwiyati_System_Architecture.png`)

### Client

- [ ] **Barcode UI + ML Kit:** decode barcode → string for lookup
- [ ] **Local notifications** for reminders (schedule/cancel)
- [ ] **Export** UI → real PDF/link flow

### Backend (Supabase Edge or equivalent)

- [ ] Barcode **drug lookup** API
- [ ] **Prompt enrichment** (+allergies, +conditions, +meds)
- [ ] **RAG** + **pgvector** queries
- [ ] **AI safety / policy** layer before returning chat responses
- [ ] **PDF maker** → **PDFMonkey** (or alternative) → secure link to app

---

## Sequence diagrams

- [ ] **`Sign_Up_Sequence_Diagram.png` / `Log_In_Sequence_Diagram.png`:** confirm email, session, redirect — match Supabase config
- [ ] **`Chatbot_Sequence_Diagram.png`:** each message → enrich → AI → safety → response
- [ ] **`Drug_Inquiry_Sequence_Diagram.png`:** scan → backend lookup → optional chat handoff
- [ ] **`Report_Generation_Sequence_Diagram.png`:** DB → PDF service → link in profile

---

## State diagrams

- [ ] **`Dose_Reminder_State_Diagram.png`:** `pending` → `taken`/`skipped` transitions enforced everywhere
- [ ] **`Medication_State_Diagram.png`:** active ↔ completed ↔ cabinet (align with dispose/end flows)
- [ ] **`CabinetMed_Expiry_State_Diagram.png` / `Active_Treatment_Expiry_State_Diagram.png`:** daily/expiry monitoring + user actions (ignore/dispose/refill)

---

## UI navigation (GP1 Table 34 / site tree)

- [ ] **Treatment details:** **Add to Cabinet** action when product requires it
- [ ] **Scan screen:** post-scan → medication detected → Add Treatment / Add Cabinet / Chatbot

---

## Quick win order (suggested)

1. Dose taken → update **quantity** + **pills_taken_so_far** + **next reminder** generation  
2. End treatment → **clear reminders** + optional **cabinet** move  
3. Edit treatment → **reschedule reminders**  
4. Cabinet → treatment → **full add-treatment parity**  
5. Scan + **backend lookup** + architecture pieces  

---

*Last aligned with codebase review (Flutter `lib/`, models, services). Update checkboxes as you implement.*
