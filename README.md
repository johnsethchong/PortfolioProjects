# This is a repository created to display four projects using four different tools for analysis: SQL Queries, Tableau, Data Cleaning, Python Analysis

COVID SQL Project: <br>
Data was gathered from https://ourworldindata.org/covid-deaths and contains COVID data including location, date, new/total cases, new/total deaths, and more. SQL queries were performed to gather specific data such as the Total Cases vs Total Deaths, Total Cases vs Population (percent of the population infected), and more. Queries performed display a proficiency in aggregate functions, joins, CTEs, temp tables, views, and more. 

COVID Tableau Project: <a href="https://public.tableau.com/app/profile/johnsethchong/viz/CovidAnalysisDashboard_16711601417130/COVIDDashboard">Tableau Visualization Link</a> <br>
Using the same data set, I performed four different queries in SQL to create spreadsheets to be used for Tableau Visualizations. All visualizations were then displayed on a dashboard for easy viewing. Visualizations include: 
- A chart showing Total Cases, Total Deaths, and death percentage
- Bar chart showing the Total Death Counter per Continent
- Line chart comparing the percent of population infected with COVID between China, India, Mexico, UK, & US. Projected forecasts are also included
- Colorized World Map displaying the percent of population infected

Data Cleaning Project: <br>
Gathered Nashville Housing data and performed SQL queries to clean data for easier analysis. Dates were reformatted, NULLs were updated with data, addresses were broken down into individual columns (Address, City, State), values were updated for consistency ('N' & 'Y' -> 'No & 'Yes', and duplicate rows were removed

Python Movie Project: <br>
Scripts were created to update datatypes, grab the correct the correct year a movie was released, and sorted for easier analysis. Scatter plots were created in Matplotlib & Seaborn to compare a movie's budget vs the gross earnings. Heat maps and matrixes were created to show the correlation between different movie features. Concluded that votes and budget have the highest correlation to gross earnings
