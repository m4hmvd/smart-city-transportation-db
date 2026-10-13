# Coursework brief — 25CSIS03C Database I project (extracted)

Source: `25CSIS03C-Coursework-Brief.pdf` in this folder. Module leader Dr. Doaa Elzanfaly,
proof read by Dr. Nermin Othman, Semester One. Project weight: **50% of the total module mark**.

Team size must be 5. Submission via Turnitin; the whole project (database + report) also goes to the
e-learning submission link, always submitted by **one** member only. The brief explicitly forbids the use
of generative AI tools such as ChatGPT for the work.

## Assessed split

40% of the project mark is group work, 60% is individual. Within the project:

| Item | Weight |
|---|---|
| Phase 1 — Database identification and preliminary design (logical design) | 40% |
| Phase 2 — Database implementation & final report | 50% |
| Presentation / discussion | 10% |

## Deliverables and dates

| Deliverable | Week stated in the body | Week stated in the schedule table | Weight |
|---|---|---|---|
| Project proposal (not graded) | Teaching Week 3 | — | not graded |
| Phase 1: description, scope, functionalities, EERD | Teaching Week 6 | Week 7 | 40% |
| Phase 2: mapping, normalisation, implementation, SQL, final report | Teaching Week 11 | Week 12 | 50% |
| Presentation to the class | Teaching Week 12 | Week 13 | 10% |

The brief contradicts itself between the body text and the schedule table (6/11/12 vs 7/12/13) —
the team should confirm the dates with the module leader rather than trust either list.

## Marking scheme — Phase 1 (stated "out of 40")

| Aspect | Full mark |
|---|---|
| Creative idea | 5 |
| Updated proposal (feedback points addressed) | 5 |
| DB scope | 3 |
| DB functionality (at least 3–4 functionalities identified) | 3 |
| Detailed description | 3 |
| Using the right symbols | 3 |
| Entities (appropriate count, singular names) | 3 |
| Attributes (incl. multivalued / composite / complex) | 3 |
| PKs (incl. candidate keys for weak entities) | 3 |
| Relationships — cardinality | 4 |
| Relationships — participation | 4 |
| English | 2 |
| Report aesthetics | 2 |
| **Sum of the listed aspects** | **43** (the brief says "Total out of 40", so the sub-marks do not add up to the stated total) |

Phase 1 is marked in a **discussion**: the team explains the design to the module leader / TAs and one member
documents the feedback and checks it with the TA.

## Marking scheme — database mapping (individual, 20% of the project mark)

| Aspect | Full mark |
|---|---|
| Modified design (feedback points addressed) | 3 |
| Entities | 5 |
| Attributes (PK, FK, composite, multivalued, complex) | 5 |
| Relationships (complete, correct arrows/arrowheads) | 10 |
| Bonus work (something not covered in the labs) | 2 |
| **Sum of the listed aspects** | **25** (brief states 20 for this section) |

Note: "Each group member MUST write very clearly his/her contribution in the creation of the entities,
attributes and relationships of the database. Marks will be deducted for messy, unclear or absent division of work."

## Marking scheme — implementation, code (individual, 30% of the project mark)

| Aspect | Mark |
|---|---|
| DDL | 10 |
| DML | 18 |
| Team cohesion | 2 |
| **Total** | **30** (the brief's column header is garbled — "(10) (18) (28) (2)") |

Also: "Evaluating constraints and data types used" is called out as a separate evaluation angle.

## Marking scheme — presentation (individual, 10%)

Graded on (1) clarity of the slides and the presentation, (2) effectiveness of using time,
(3) how well questions are answered. Score: Skills 4 + Questions 6 = 10.

## Phase requirements in the team's words

* **Proposal (week 3, not graded):** project title, student names, IDs, e-mails, and a one-paragraph
  description of the database.
* **Phase 1 (40%):** cover with title / names / IDs / e-mails; detailed description of the database, its scope
  and functionalities; the conceptual schema (EERD) identifying entities, attributes, relationships,
  constraints, specialisation/generalisation constraints, etc.
* **Phase 2 (50%):** map the conceptual model into an implementation model; normalise the schema; implement the
  database; use SQL to access and manipulate the data; final report documenting the whole database plus the code.
* **Presentation (10%):** a PowerPoint presentation to the class.
