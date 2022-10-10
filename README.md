# Retreat

## Table of Contents
+ [Project Video](https://drive.google.com/file/d/1dmiEA8cbPboJqdFlaUqBhVrn2HHsB07z/view?usp=sharing)
+ [Project Poster](https://drive.google.com/file/d/1ygT7aayeGPTi6Q92ARf3A15JZOIxby_g/view?usp=sharing)
+ [Project Proposal](https://drive.google.com/file/d/1voS4iBdbeol3E9BKTEkFNUBYPbWZFzMn/view?usp=sharing)
+ [Motivation](https://github.com/Rachel-AG/CP2106-Orbital#motivation)
+ [Aim](https://github.com/Rachel-AG/CP2106-Orbital#aim)
+ [User Stories](https://github.com/Rachel-AG/CP2106-Orbital#user-stories)
+ [Features](https://github.com/Rachel-AG/CP2106-Orbital#features)
+ [Timeline and Development Plan](https://github.com/Rachel-AG/CP2106-Orbital#timeline-and-development-plan)
+ [Tech Stack](https://github.com/Rachel-AG/CP2106-Orbital#tech-stack)
+ [Useful Links](https://github.com/Rachel-AG/CP2106-Orbital#tech-stack)

## Motivation

Tracking our expenses is important to maintain good financial health. Unfortunately, many of us often give up halfway during the repetitive and dull process of recording each of our transactions. Fret not, **Retreat** will re-engineer your experience in budgeting! Introducing Retreat, a gamified money management app that can help you develop healthy spending habits.

Watch your retreat island grow as your savings grow!

## Aim

We aim to improve users' financial health by nurturing good spending habits through a fun and interactive money management mobile application that incentivizes users to continue recording their each and every expenses.

## User Stories

| **S/N** | **As a/an ...**                  | **I want to ...**                                                              |
|---------|----------------------------------|--------------------------------------------------------------------------------|
| 1       | private person                   | create my own secure account                                                   |
| 2       | owner of multiple mobile devices | access my account from multiple devices                                        |
| 3       | busy person                      | track my cash flow quickly and efficiently                                     |
| 4       | visual person                    | visualize my cash flows through charts and graphs                              |
| 5       | easily bored person              | make my bookkeeping experience fun and engaging                                |
| 6       | forgetful person                 | be able to retrieve my account in the event that I forgot my password/username |
| 7       | forgetful person                 | be frequently reminded about my available budget                               |

## Features

The following are Retreat’s main features. Note that the figures below are prototypes and might not fully represent the final product.

### Account Database

There are 3 main functionalities of this feature:

1. Users should be able to create and delete their accounts accordingly.
2. Users should be able to sign in and sign out of their accounts on any mobile devices.
3. Users should be able to retrieve their account by using the “forget password?” function.

### Bookkeeping Functions

#### Budgeting

At the start of each month, users will be prompted to set their budget for the month. The remaining amount available will be displayed in the Homepage to remind users how much they have left for the current month. Thus, users will be reminded of their budget everytime they open the application.

#### Record and Delete

Users should be able to record and delete their expenses and income using their chosen currency. Each record can be categorized to one specific category. There will be an in-built basic calculator inside the application to allow users to conveniently calculate their spending or income.

#### Charts and Graphs

By retrieving the records from the database, users should be able to view various charts and graphs. Spending in each category can be easily identified using the account balance summary. Users can also easily track how much they spend in total or in each category every month. This allow the users to visualize their spending habits easily.

#### Recurring Transactions

For convenience purposes, users should be able to set up recurring expenses or incomes. Users have the option to choose the duration of the cycle (i.e. daily, weekly, monthly, among others). These expenses or incomes will be automatically incurred on users’ accounts. Should there be any changes, users should be able to modify or delete these recurring transactions.

### Gamified Aspects

Retreat includes a simple world building game to enhance users’ experience and to incentivise users to continue using our app. There are 3 main features of this game: Island Building, Builder Store, Leaderboard.

#### Island Building

Island Building is the centerpiece of the game. Users will initially start with a plot of land (a hexagon) to represent their island. Users can expand their island further by buying plots of land in the Builder Store using COINS, which is Retreat’s in-game currency.

COINS is obtained when a user record a transaction. The amount of COINS obtained is dependent on whether the user spends within his predetermined budget for each month. This will help to cultivate healthy spending habits among our users. Users will also receive more coins depending on the number of consecutive daily check-in. This encourages user to record all their transactions.

#### Builder Store

Builder Store is where users buy plots of lands / building pieces (which can be placed on top of an empty plot of land) to expand their island using their COINS.

#### Leaderboard

Retreat has a global leaderboard system based on users’ island progress to further motivate users to improve their spending habits.

## Timeline and Development Plan

| **MS** | **Task**                                  | **Description**                                                                                    | In-charge       | Date              |
|--------|-------------------------------------------|----------------------------------------------------------------------------------------------------|-----------------|-------------------|
| 1      | Preliminary research into app development | Familiarize ourselves with Flutter and Supabase, learn how to integrate front-end with back-end    | Rachel Vinessa  | 12 - 22 May       |
|        | Account                                   | Account creation, login and logout, and account retrieval                                          | Rachel          | 22 - 30 May       |
|        | Basic Bookkeeping Functions               | Record and display expenses, categorize expenses                                        | Vinessa         | 22 - 30 May       |
| 2      | Bookkeeping Functions                           | Delete and edit expenses, add time, set budget                                    | Vinessa | Week 5 - Week 6   |
|        | User Interface                            |                                                                                                    | Rachel  Vinessa | Week 5 - Week 6   |
|        | Charts and Graphs                         | Produce charts from existing data                                                                  | Rachel          | Week 7            |
|        | Island Building Mechanics                 | Tile object system, basic functionalities for building the island (eg. moving the pieces)          | Rachel Vinessa  | Week 7 -  Week 8  |
| 3      | COINS System                              | Complete system to be used for in-game currency, Builder Store                                     | Rachel Vinessa  | Week 9 -  Week 11 |
|        | Advance Bookkeeping Functions             | Recurring expenses and income, mathematical functions                                              | Vinessa         | Week 12           |
|        | Leaderboard                               | Island Progress                                                                                    | Rachel          | Week 12           |
| 4      | Refinement                                | Testing and debugging : COINS system, Island progress (progression difficulty), Refining UI and UX | Rachel Vinessa  | Week 13 - Week 16 |
|        | Island Building Mechanics                 | Visual and sound effects                                                                           | Vinessa         | Week 13 - Week 14 |

## Tech Stack

Since Retreat is a mobile application, we are planning to use several tools commonly used in the development of applications.

Front-end: Dart, Flutter

Back-end: Supabase, Java

## Useful Links

[Game assets](https://www.kenney.nl/assets/hexagon-kit)
