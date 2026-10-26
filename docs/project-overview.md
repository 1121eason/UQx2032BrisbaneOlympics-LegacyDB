# Project overview

## Context and intended users

Brisbane 2032 Athletes’ Village management is modelled as a temporary smart-city operation followed by a long-term legacy programme. The fictional teaching case requires a core database plus one expansion track. The team chose **Option A: Green Legacy**.

The intended users are village operations managers, sustainability analysts, infrastructure planners and legacy programme managers. Medical entities support operational links and encounters; the system is not a full electronic health record or appointment application.

## From operations to legacy

| Stage | Records captured | Management questions |
| --- | --- | --- |
| Games preparation and operations | People, roles, rooms, facilities, services and allocations | Who belongs to which delegation or role, and where are rooms and services located? |
| Environmental monitoring | Energy/water sources and meters, readings, general and clinical waste | Where are resource demand and waste concentrated? |
| Asset second life | Suppliers, sustainability ratings, asset inventories and disposal records | Which assets have a recorded recycling, donation or resale plan? |
| Building transformation | Contractors, conversion projects, tasks and room-use changes | What is being converted, for which future use and by whom? |
| Community benefit | Local employment and work activities | How much participation and work time is associated with local residents? |

The links across these stages are the value of the database. For example, a building connects energy consumption, room accessibility, assets and conversion projects. A conversion project links its contractor to workforce activity and target legacy use.

## Technical implementation

- MySQL 8 relational schema using InnoDB, primary keys, composite keys and foreign-key relationships.
- Separate reference entities for sources, categories, countries, roles, specialties and services.
- Junction tables for clinic services, encounter services and encounter staff.
- Five reporting views and six reporting files using joins, CTEs, window functions and date-based aggregation.
- Historical data cleaning and test-data generation documented in the original report.
- This repository adds execution packaging, generated schema documentation, validation scripts and transparent provenance. These additions are distinct from the original semester submission.

## Demonstration status

The delivered database is an academic prototype with demo data. A relational design and reports exist; a deployed application, production permissions, authentication, automated ingestion, operational audit logging and measured sustainability outcomes are not delivered by these files. Availability of a schema column does not establish that its corresponding workflow or control has been implemented.

## What this demonstrates in a portfolio

The project connects SQL database development and data analysis. It demonstrates translating business requirements into related entities, building and querying the relational structure, and interpreting outputs with explicit metric populations and limitations.

For database-development evidence, start with the [SQL skills walkthrough](sql-skills.md). For analytical evidence, read the [business cases](business-case-studies.md), which connect observed demo results to operational decisions. The [career positioning guide](career-positioning.md) supplies DB and Data Analyst presentation paths while keeping individual and team contributions distinct.
