
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dputsql

<!-- badges: start -->
<!-- badges: end -->

The goal of dputsql is to create `CREATE TABLE` and `INSERT INTO` SQL
statements directly from objects within R. No DBI connection required.
Outputs have not been exhaustively tested against numerous engines.
Works mostly with SQLite and MySQL formatting.

## Installation

You can install the development version of dputsql like so:

``` r
remotes::install_github("daranzolin/dputsql")
```

## Example

The simplest use to call `dputsql` on any dataframe:

``` r
library(dputsql)
dputsql(mtcars)
#> CREATE TABLE IF NOT EXISTS x (
#>  mpg numeric,
#>  cyl numeric,
#>  disp numeric,
#>  hp numeric,
#>  drat numeric,
#>  wt numeric,
#>  qsec numeric,
#>  vs numeric,
#>  am numeric,
#>  gear numeric,
#>  carb numeric
#> );
#> 
#> INSERT INTO x (`mpg`, `cyl`, `disp`, `hp`, `drat`, `wt`, `qsec`, `vs`, `am`, `gear`, `carb`) VALUES
#>  (21,6,160,110,3.9,2.62,16.46,0,1,4,4),
#>  (21,6,160,110,3.9,2.875,17.02,0,1,4,4),
#>  (22.8,4,108,93,3.85,2.32,18.61,1,1,4,1),
#>  (21.4,6,258,110,3.08,3.215,19.44,1,0,3,1),
#>  (18.7,8,360,175,3.15,3.44,17.02,0,0,3,2),
#>  (18.1,6,225,105,2.76,3.46,20.22,1,0,3,1),
#>  (14.3,8,360,245,3.21,3.57,15.84,0,0,3,4),
#>  (24.4,4,146.7,62,3.69,3.19,20,1,0,4,2),
#>  (22.8,4,140.8,95,3.92,3.15,22.9,1,0,4,2),
#>  (19.2,6,167.6,123,3.92,3.44,18.3,1,0,4,4),
#>  (17.8,6,167.6,123,3.92,3.44,18.9,1,0,4,4),
#>  (16.4,8,275.8,180,3.07,4.07,17.4,0,0,3,3),
#>  (17.3,8,275.8,180,3.07,3.73,17.6,0,0,3,3),
#>  (15.2,8,275.8,180,3.07,3.78,18,0,0,3,3),
#>  (10.4,8,472,205,2.93,5.25,17.98,0,0,3,4),
#>  (10.4,8,460,215,3,5.424,17.82,0,0,3,4),
#>  (14.7,8,440,230,3.23,5.345,17.42,0,0,3,4),
#>  (32.4,4,78.7,66,4.08,2.2,19.47,1,1,4,1),
#>  (30.4,4,75.7,52,4.93,1.615,18.52,1,1,4,2),
#>  (33.9,4,71.1,65,4.22,1.835,19.9,1,1,4,1),
#>  (21.5,4,120.1,97,3.7,2.465,20.01,1,0,3,1),
#>  (15.5,8,318,150,2.76,3.52,16.87,0,0,3,2),
#>  (15.2,8,304,150,3.15,3.435,17.3,0,0,3,2),
#>  (13.3,8,350,245,3.73,3.84,15.41,0,0,3,4),
#>  (19.2,8,400,175,3.08,3.845,17.05,0,0,3,2),
#>  (27.3,4,79,66,4.08,1.935,18.9,1,1,4,1),
#>  (26,4,120.3,91,4.43,2.14,16.7,0,1,5,2),
#>  (30.4,4,95.1,113,3.77,1.513,16.9,1,1,5,2),
#>  (15.8,8,351,264,4.22,3.17,14.5,0,1,5,4),
#>  (19.7,6,145,175,3.62,2.77,15.5,0,1,5,6),
#>  (15,8,301,335,3.54,3.57,14.6,0,1,5,8),
#>  (21.4,4,121,109,4.11,2.78,18.6,1,1,4,2);
```

For more control, you can create the table and specify constraints like
so:

``` r
library(charlatan)
suppressPackageStartupMessages(library(tidyverse))

df <- ch_generate("name", "job", "phone_number", "currency", "color_name") |>
  mutate(id = row_number(), .before = 1) |>
  mutate(varx = sample(1:100, 10))

df |> 
  create_table() |> 
  primary_key("id") |> 
  not_null(c("name", "job")) |> 
  unique_vals(c("phone_number", "job")) |> 
  default_vals(list(currency = "ENG")) |> 
  check_vals(list(varx = "varx > 0")) |> 
  add_insert_statement()
#> CREATE TABLE IF NOT EXISTS df (
#>  id integer PRIMARY KEY,
#>  name text NOT NULL,
#>  job text NOT NULL UNIQUE,
#>  phone_number text UNIQUE,
#>  currency text   DEFAULT ENG,
#>  color_name text,
#>  varx integer  CHECK(varx > 0)
#> );
#> 
#> INSERT INTO df (`id`, `name`, `job`, `phone_number`, `currency`, `color_name`, `varx`) VALUES
#>  (1,'Mr. Darold Trantow IV','Designer, interior/spatial','1-247-551-1720x4089','ZAR','Fuchsia',56),
#>  (2,'Philo Gulgowski DDS','Musician','703.698.8590x0651','SHP','Aqua',53),
#>  (3,'Almyra Runolfsson','Doctor, general practice','429.448.7165x96196','DKK','LightPink',72),
#>  (4,'Dr. Jim Bailey DDS','Bookseller','263-534-7400','NPR','Cornsilk',17),
#>  (5,'Mrs. Kailyn Bode DVM','Nutritional therapist','1-109-195-9233x75019','BZD','CornflowerBlue',35),
#>  (6,'Emilio Volkman','Journalist, magazine','006-968-2239x230','PGK','BlueViolet',67),
#>  (7,'Jeffry Kulas','Veterinary surgeon','1-553-623-5959','AOA','DarkSeaGreen',31),
#>  (8,'Kennth Schulist','Statistician','1-925-014-7928x4579','NGN','Coral',28),
#>  (9,'Eulah Paucek','Call centre manager','253-968-7770x579','OMR','LightSalmon',29),
#>  (10,'Anastacio Gutkowski','Animal technologist','064-719-7466','PAB','MintCream',100);
```

Write the output to a file, or send it to your clipboard:

``` r
dputsql(mtcars) |> 
  write_ddl_file("CREATE.sql")

dputsql(mtcars) |> 
  ddl_to_clipboard()
```
