
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Environmental attitudes: natural language processing of social media posts

<!-- badges: start -->
<!-- badges: end -->

The goal of this hackathon session is to find out how we can use social
media data to find peoples attitudes to different environmental
challenges or aspects of nature.

I am hopeful that the work we do today can inform a peer reviewed paper
on environmental attitudes and social media data.

## Installation

To access code designed for these type of analysis we need to install
and library ‘R packages’. R packages can be downloaded from several
locations. Packages can be officially hosted on the ‘CRAN repository’,
while other packages can be downloaded from sites such as github. The
`devtools` package allows for better loading of uninstalled packages
hosted on github.

You can install and load the code for this hackathon session from
[GitHub](https://github.com/nfox29/seasHackathon) and the tools for
searching social media websites with:

``` r
install.packages("devtools")
library(devtools)

devtools::install_github("nfox29/seasHackathon")
library(seasHackathon)

devtools::install_github("ropensci/photosearcher")
library(photosearcher)
```

## Flickr

Flickr is an image and video hosting service with an estimated 90
million monthly users. This include over 75 million registered
photographers. These user upload almost 25 million photograph a day. It
was created by Ludicorp in 2004, and has changed ownership several times
and has been owned by SmugMug since April 20, 2018.

``` r
library(photosearcher)
```

The first time you run any `photosearcher` code it will prompt you to
make and enter your unique Flickr API key from the [API
website](https://www.flickr.com/services/apps/create/). Entering this
into the console will save it as a .sysdata file type that will be then
automatically used anytime you run a photosearcher function. If you make
a mistake or your key stops working, just delete the .sysdata file and
the next time you run a function it will prompt you to enter a new api
key.

In the following example we will run a basic search to make sure that
everyone is able to run the photosearcher functions correctly. Here, we
search for any photograph taken on the 1st week of Janurary 2021
accompanied by any text that says “landscape”. The basic search for data
from Flickr also involves searching within a specific area known as a
[bounding
box](http://bboxfinder.com/#0.000000,0.000000,0.000000,0.000000)?. The
bounding box is a set of coordinates that represent the bottom left and
top right of an area. We can use this as an argument in the
photosearcher R package to find all photographs within that box.

``` r
#search flickr for posts containing the word "nature" in a give place and time
flickr_raw <- photo_search(mindate_taken = "2021-01-01",
                           maxdate_taken = "2021-01-07",
                           bbox = "-134.648443,21.398553,-54.140630,49.925909",
                           text = "landscape")
```

The photosearcher R package also allows you to search for an area based
on a shape file. In R we are dealing with shape files by reading them in
using the `sf` package. Here, we read in a sample shape file called `nc`
from the `sf` package. This shape file is made up of 100 different
regions. We then use this as an argument in the `photo_search()`
function to find all photographs taken within the boundaries of each of
the 100 different shapes during the first three months of 2022. You may
notice that the outputs have some additional column `within` compared to
before. The `within` column represents which of the 100 different
boundaries that photograph belongs to.

``` r
library("sf")
#> Linking to GEOS 3.9.1, GDAL 3.4.3, PROJ 7.2.1; sf_use_s2() is TRUE

nc <- st_read(system.file("shape/nc.shp", package="sf"))
#> Reading layer `nc' from data source 
#>   `C:\Users\Nathan\AppData\Local\R\win-library\4.2\sf\shape\nc.shp' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 100 features and 14 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> Geodetic CRS:  NAD27

flickr_photos <- photo_search(mindate_taken = "2020-01-01",
                              maxdate_taken = "2022-01-01",
                              sf_layer = nc,
                              text = "nature")
head(flickr_photos, 1)
#>   license          id        owner     secret server farm                 title
#> 1       0 49315569898 27847413@N00 774655c8f5  65535   66 Thursday Morning Sky.
#>   ispublic isfriend isfamily          dateupload          lastupdate
#> 1       NA       NA       NA 2020-01-02 14:17:32 2020-01-04 14:25:20
#>             datetaken datetakengranularity datetakenunknown count_views
#> 1 2020-01-02 08:38:49                    0                0         288
#>   count_faves count_comments
#> 1           0              0
#>                                                                                                                                                                                                                                                  tags
#> 1 lumberton nc northcarolina robesoncounty outdoor outdoors outside nature natural branch treebranch branches treebranches sky cloud clouds treelimb treelimbs january thursday morning winter thursdaymorning goodmorning canon powershot elph 520hs
#>   accuracy context place_id   woeid geo_is_public geo_is_contact geo_is_friend
#> 1       16       0          7230372            NA             NA            NA
#>   geo_is_family
#> 1            NA
#>                                                             url_sq height_sq
#> 1 https://live.staticflickr.com/65535/49315569898_774655c8f5_s.jpg        75
#>   width_sq                                                            url_t
#> 1       75 https://live.staticflickr.com/65535/49315569898_774655c8f5_t.jpg
#>   height_t width_t
#> 1       75     100
#>                                                              url_s height_s
#> 1 https://live.staticflickr.com/65535/49315569898_774655c8f5_m.jpg      180
#>   width_s                                                            url_q
#> 1     240 https://live.staticflickr.com/65535/49315569898_774655c8f5_q.jpg
#>   height_q width_q
#> 1      150     150
#>                                                            url_m height_m
#> 1 https://live.staticflickr.com/65535/49315569898_774655c8f5.jpg      375
#>   width_m                                                            url_n
#> 1     500 https://live.staticflickr.com/65535/49315569898_774655c8f5_n.jpg
#>   height_n width_n url_o height_o width_o
#> 1      240     320  <NA>       NA      NA
#>                                                              url_z height_z
#> 1 https://live.staticflickr.com/65535/49315569898_774655c8f5_z.jpg      480
#>   width_z                                                            url_c
#> 1     640 https://live.staticflickr.com/65535/49315569898_774655c8f5_c.jpg
#>   height_c width_c
#> 1      600     800
#>                                                              url_l height_l
#> 1 https://live.staticflickr.com/65535/49315569898_774655c8f5_b.jpg      768
#>   width_l
#> 1    1024
#>                                                               description
#> 1 Tree branches, sky and clouds at the property where my wife and I live.
#>   longitude latitude                 geometry within        license_name
#> 1 -78.98248 34.62034 c(-78.982484, 34.620338)     94 All Rights Reserved
#>   license_url
#> 1          NA
```

## Reddit

Reddit may be unfamiliar to you as a social media website. The main home
page of Reddit is an accumulation of the most liked and commented posts
from a given time period. You can filter and sort by time, or display a
feed of what the most recent posts are.

Posts on Reddit are made to specific pages where users can posts about a
dedicated topic. This pages are called subreddits. Subreddits exist for
a wide range of different topics including [landscape
photography](https://www.reddit.com/r/EarthPorn/),
[hiking](https://www.reddit.com/r/hiking/). These subreddits have
different posting rules, for example some only allows image posts, while
others only allow textual posts. Lets take a second to explore Reddit.

First, lets take a look at “r/EarthPorn”. Now, don’t be fooled by the
name EarthPorn is not adult content but a collection of professional
quality photographs of landscapes.There is also an armature level
equivalent call “r/AmatureEarthPorn”.

EarthPorn has strict criteria for what can be posted. Only landscape
images acompanied by the title of the images location are allowed. Other
subreddits have more relaxed rules and allow posts of all kind, as long
as they are on topic.

Though data from Reddit has been used in a wide range of research
disciplines such as political sciences, health sciences and
technological development, it has not yet been widely explored for
environmental sciences. We however believe that there is a great
opportunity for a wide range of environmental applications as explored
in [this
paper](https://www.sciencedirect.com/science/article/pii/S2212041621000899)

As with searching for Flickr photographs, the `photosearcher` package
provides functionality to search Reddit for data. Please note that this
function has just been developed for public use and has not been as
robustly tested as the Flickr search, so if we get some unexpected
errors please do not worry! We will also load some other packages that
provide some nice functionality for accessing Reddit data.

``` r
library("photosearcher")
library("dplyr")
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

Lets start by searching for posts associated with a specific term. For
example, lets find all the posts associated with the word waterfall. The
function is set up similar to the `photo_search()` function so we need
to supply a start and end date. As Reddit has a massive database of
posts lets quickly search for just one week. Reddit does allow for adult
content, or not safe for work posts (NSFW), so to ensure these are
removed we can select only posts that are not labeled as `over_18`.

``` r
reddit_data <- reddit_search(search_term = "waterfall",
                             start_date = "2022-01-01",
                             end_date = "2022-01-08") %>% 
  subset(over_18 == "FALSE") #remove over 18 content
#> ================================================================================

#inspect data
head(reddit_data)[-1] #the -1 is to hide the authors names
#>   created_utc
#> 1  1641014013
#> 2  1641014014
#> 3  1641016424
#> 4  1641018505
#> 5  1641018796
#> 6  1641019544
#>                                                                               title
#> 1         [#778|+1321|72] Getting too close to the edge of a waterfall [r/nononono]
#> 2 [#73|+15148|733] Getting too close to the edge of a waterfall [r/WinStupidPrizes]
#> 3                                                                   New to the game
#> 4                                                Help beating Elite 4 and Champion?
#> 5                             Navbar collapse menu not responding (Bootstrap 5.1.3)
#> 6                                                      Add Waterfalls To Minecraft.
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        selftext
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      And I wanted to shout out the deino who spared my little tenos life when I fell down a waterfall and couldn’t get out. When I fell I saw the deino swimming behind me and I panicked thinking I was done for. Eventually they swam ahead of me and thought maybe they’re trying to help since they hadn’t killed me yet. I followed them down the river, saw them turn onto land and I was able to get out finally! Gave them a friendly teno thank you and went on my way. \n\nThis happened last week when I first bought the game, but I think of it a lot. Loving this game so far, and have had both good and bad experiences, but mainly good ones! \n\nThank you!
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Hey everyone, I could use some help.  I've gone up against the Elite 4 and Cynthia twice now, and Cynthia stops me in my tracks with her Lucario.  Can someone tell me what I'm doing wrong?  Here's my current team:\n\nGyarados lvl 59\nRelaxed\nCrunch\nIce Fang\nDragon Dance\nWaterfall\n\nJirachi lvl 60\nLonely\nWise Glasses\nPsychic\nWish\nDazzling Gleam\nMeteor Mash\n\nGarchomp lvl 61\nSassy\nLeftovers\nEarthquake\nCrunch\nBulldoze\nDragon Pulse\n\nRoserade lvl 64\nLax\nShell Bell\nPetal Blizzard\nGiga Drain\nShadow Ball\nSludge Bomb\n\nInfernape lvl 66\nMild\nFlame Wheel\nPower-Up Punch\nAcrobatics\nClose Combat\n\nLuxray lvl 67\nSerious\nCrunch\nThunder Wave\nSpark\nDischarge\n\nNone of these pokemon have been bred, which I realize now is probably a big part of the problem as their natures really line up with their roles on the team.  I have unlocked the National Pokedex, so I'm gonna start hunting for Ditto in order to start breeding.  I also read an article earlier that gave a recommended team to successfully beat Cynthia, but I can't find it now.  I do remember that Lucario was on the list, but I just barely hatched the Riolu before my first E4 attempt.  Do yall have any suggestions as to best team with Infernape as your starter?\n\nThanks for taking the time to read this, and thanks in advance for any help and suggestions!
#> 5 Hey all, I'm currently taking a Udemy course and have exhausted myself trying to figure out why the collapse menu won't respond. I tried to use the separate JS lines on [getbootstrap.com](https://getbootstrap.com) as well as the bundle and no luck with either method. I've tried placing the &lt;/script&gt; tag at the end right before the &lt;/body&gt; tag and still having no luck with it. Was wondering if any of you could help me figure it out?\n\n&amp;#x200B;\n\nCode is below\n\n\\-------------------------------------\n\n&lt;!DOCTYPE html&gt;\n\n&lt;html&gt;\n\n&amp;#x200B;\n\n&lt;head&gt;\n\n&amp;#x200B;\n\n  &lt;meta charset="utf-8"&gt;\n\n  &lt;title&gt;TinDog&lt;/title&gt;\n\n&amp;#x200B;\n\n&lt;!-- Google Fonts --&gt;\n\n  &lt;link rel="preconnect" href="[https://fonts.googleapis.com](https://fonts.googleapis.com)"&gt;\n\n  &lt;link rel="preconnect" href="[https://fonts.gstatic.com](https://fonts.gstatic.com)" crossorigin&gt;\n\n  &lt;link\n\nhref="[https://fonts.googleapis.com/css2?family=Dancing+Script&amp;family=Imperial+Script&amp;family=Licorice&amp;family=Mea+Culpa&amp;family=Merriweather&amp;family=Montserrat:wght@900&amp;family=Sacramento&amp;family=The+Nautigal&amp;family=Ubuntu&amp;family=Waterfall&amp;display=swap](https://fonts.googleapis.com/css2?family=Dancing+Script&amp;family=Imperial+Script&amp;family=Licorice&amp;family=Mea+Culpa&amp;family=Merriweather&amp;family=Montserrat:wght@900&amp;family=Sacramento&amp;family=The+Nautigal&amp;family=Ubuntu&amp;family=Waterfall&amp;display=swap)"\n\nrel="stylesheet"&gt;\n\n&amp;#x200B;\n\n&lt;!-- CSS Stylesheets --&gt;\n\n&lt;link href="[https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css](https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css)" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous"&gt;\n\n&lt;link rel="stylesheet" href="css/styles.css"&gt;\n\n&amp;#x200B;\n\n&lt;!-- Font Awesome --&gt;\n\n  &lt;script src="[https://kit.fontawesome.com/cc7d1c67b8.js](https://kit.fontawesome.com/cc7d1c67b8.js)" crossorigin="anonymous"&gt;&lt;/script&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;/head&gt;\n\n&amp;#x200B;\n\n&lt;body&gt;\n\n&amp;#x200B;\n\n  &lt;section id="title"&gt;\n\n&amp;#x200B;\n\n&lt;div class="container-fluid"&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;!-- Nav Bar --&gt;\n\n&lt;nav class="navbar navbar-expand-lg navbar-dark"&gt;\n\n&amp;#x200B;\n\n&lt;a class="navbar-brand" href=""&gt;tindog&lt;/a&gt;\n\n&amp;#x200B;\n\n&lt;button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation"&gt;\n\n&lt;span class="navbar-toggler-icon"&gt;&lt;/span&gt;\n\n&lt;/button&gt;\n\n&amp;#x200B;\n\n&lt;div class="collapse navbar-collapse" id="navbarNavDropdown"&gt;\n\n&lt;ul class="navbar-nav ms-auto"&gt;\n\n&lt;li class="nav-item"&gt;\n\n&lt;a class="nav-link" href=""&gt;Contact&lt;/a&gt;\n\n&lt;/li&gt;\n\n&amp;#x200B;\n\n&lt;li class="nav-item"&gt;\n\n&lt;a class="nav-link" href=""&gt;Pricing&lt;/a&gt;\n\n&lt;/li&gt;\n\n&amp;#x200B;\n\n&lt;li class="nav-item"&gt;\n\n&lt;a class="nav-link" href=""&gt;Download&lt;/a&gt;\n\n&lt;/li&gt;\n\n&lt;/ul&gt;\n\n&lt;/div&gt;\n\n&lt;/nav&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;!-- Title --&gt;\n\n&lt;div class="row"&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;div class="col-lg-6"&gt;\n\n&lt;h1&gt;Meet new and interesting dogs nearby.&lt;/h1&gt;\n\n&lt;button type="button" class="btn btn-dark btn-lg"&gt;&lt;i class="fab fa-apple"&gt;&lt;/i&gt; Download&lt;/button&gt;\n\n&lt;button type="button" class="btn btn-outline-light btn-lg"&gt;&lt;i class="fab fa-google-play"&gt;&lt;/i&gt; Download&lt;/button&gt;\n\n&lt;/div&gt;\n\n&amp;#x200B;\n\n&lt;div class="col-lg-6"&gt;\n\n&lt;img src="images/iphone6.png" alt="iphone-mockup"&gt;\n\n&lt;/div&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;/div&gt;\n\n&amp;#x200B;\n\n&lt;/div&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Features --&gt;\n\n&amp;#x200B;\n\n  &lt;section id="features"&gt;\n\n&amp;#x200B;\n\n&lt;h3&gt;Easy to use.&lt;/h3&gt;\n\n&lt;p&gt;So easy to use, even your dog could do it.&lt;/p&gt;\n\n&amp;#x200B;\n\n&lt;h3&gt;Elite Clientele&lt;/h3&gt;\n\n&lt;p&gt;We have all the dogs, the greatest dogs.&lt;/p&gt;\n\n&amp;#x200B;\n\n&lt;h3&gt;Guaranteed to work.&lt;/h3&gt;\n\n&lt;p&gt;Find the love of your dog's life or your money back.&lt;/p&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Testimonials --&gt;\n\n&amp;#x200B;\n\n  &lt;section id="testimonials"&gt;\n\n&amp;#x200B;\n\n&lt;h2&gt;I no longer have to sniff other dogs for love. I've found the hottest Corgi on TinDog. Woof.&lt;/h2&gt;\n\n&lt;img src="images/dog-img.jpg" alt="dog-profile"&gt;\n\n&lt;em&gt;Pebbles, New York&lt;/em&gt;\n\n&amp;#x200B;\n\n&lt;!-- &lt;h2 class="testimonial-text"&gt;My dog used to be so lonely, but with TinDog's help, they've found the love of their life. I think.&lt;/h2&gt;\n\n&lt;img class="testimonial-image" src="images/lady-img.jpg" alt="lady-profile"&gt;\n\n&lt;em&gt;Beverly, Illinois&lt;/em&gt; --&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Press --&gt;\n\n&amp;#x200B;\n\n  &lt;section id="press"&gt;\n\n&lt;img src="images/techcrunch.png" alt="tc-logo"&gt;\n\n&lt;img src="images/tnw.png" alt="tnw-logo"&gt;\n\n&lt;img src="images/bizinsider.png" alt="biz-insider-logo"&gt;\n\n&lt;img src="images/mashable.png" alt="mashable-logo"&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Pricing --&gt;\n\n&amp;#x200B;\n\n  &lt;section id="pricing"&gt;\n\n&amp;#x200B;\n\n&lt;h2&gt;A Plan for Every Dog's Needs&lt;/h2&gt;\n\n&lt;p&gt;Simple and affordable price plans for your and your dog.&lt;/p&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;h3&gt;Chihuahua&lt;/h3&gt;\n\n&lt;h2&gt;Free&lt;/h2&gt;\n\n&lt;p&gt;5 Matches Per Day&lt;/p&gt;\n\n&lt;p&gt;10 Messages Per Day&lt;/p&gt;\n\n&lt;p&gt;Unlimited App Usage&lt;/p&gt;\n\n&lt;button type="button"&gt;Sign Up&lt;/button&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;h3&gt;Labrador&lt;/h3&gt;\n\n&lt;h2&gt;$49 / mo&lt;/h2&gt;\n\n&lt;p&gt;Unlimited Matches&lt;/p&gt;\n\n&lt;p&gt;Unlimited Messages&lt;/p&gt;\n\n&lt;p&gt;Unlimited App Usage&lt;/p&gt;\n\n&lt;button type="button"&gt;Sign Up&lt;/button&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n&lt;h3&gt;Mastiff&lt;/h3&gt;\n\n&lt;h2&gt;$99 / mo&lt;/h2&gt;\n\n&lt;p&gt;Pirority Listing&lt;/p&gt;\n\n&lt;p&gt;Unlimited Matches&lt;/p&gt;\n\n&lt;p&gt;Unlimited Messages&lt;/p&gt;\n\n&lt;p&gt;Unlimited App Usage&lt;/p&gt;\n\n&lt;button type="button"&gt;Sign Up&lt;/button&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Call to Action --&gt;\n\n&amp;#x200B;\n\n  &lt;section id="cta"&gt;\n\n&amp;#x200B;\n\n&lt;h3&gt;Find the True Love of Your Dog's Life Today.&lt;/h3&gt;\n\n&lt;button type="button"&gt;Download&lt;/button&gt;\n\n&lt;button type="button"&gt;Download&lt;/button&gt;\n\n&amp;#x200B;\n\n  &lt;/section&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Footer --&gt;\n\n&amp;#x200B;\n\n  &lt;footer id="footer"&gt;\n\n&amp;#x200B;\n\n&lt;p&gt;© Copyright 2018 TinDog&lt;/p&gt;\n\n&amp;#x200B;\n\n  &lt;/footer&gt;\n\n&amp;#x200B;\n\n&amp;#x200B;\n\n  &lt;!-- Bootstrap Scripts --&gt;\n\n&amp;#x200B;\n\n&lt;script src="[https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js](https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js)" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"&gt;&lt;/script&gt;\n\n&amp;#x200B;\n\n&lt;/body&gt;\n\n&amp;#x200B;\n\n&lt;/html&gt;
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Waterfalls should be added to minecraft, specifically as now the wild update (a.k.a 1.19) is arriving, the waterfall should have a lil rare chances of spawning with a secret cave...
#>                                                                                                     url
#> 1            http://reddit.com/r/nononono/comments/rt16mj/getting_too_close_to_the_edge_of_a_waterfall/
#> 2     http://reddit.com/r/WinStupidPrizes/comments/rt15p4/getting_too_close_to_the_edge_of_a_waterfall/
#> 3                                     https://www.reddit.com/r/theisle/comments/rtcu08/new_to_the_game/
#> 4               https://www.reddit.com/r/PokemonBDSP/comments/rtddj5/help_beating_elite_4_and_champion/
#> 5 https://www.reddit.com/r/bootstrap/comments/rtdgha/navbar_collapse_menu_not_responding_bootstrap_513/
#> 6            https://www.reddit.com/r/minecraftsuggestions/comments/rtdn5m/add_waterfalls_to_minecraft/
#>                                                                         permalink
#> 1       /r/longtail/comments/rtc6sn/778132172_getting_too_close_to_the_edge_of_a/
#> 2      /r/undelete/comments/rtc6t0/7315148733_getting_too_close_to_the_edge_of_a/
#> 3                                     /r/theisle/comments/rtcu08/new_to_the_game/
#> 4               /r/PokemonBDSP/comments/rtddj5/help_beating_elite_4_and_champion/
#> 5 /r/bootstrap/comments/rtdgha/navbar_collapse_menu_not_responding_bootstrap_513/
#> 6            /r/minecraftsuggestions/comments/rtdn5m/add_waterfalls_to_minecraft/
#>   score num_comments            subreddit over_18        date_created
#> 1     1            0             longtail   FALSE 2022-01-01 00:13:33
#> 2     1            0             undelete   FALSE 2022-01-01 00:13:34
#> 3     1            0              theisle   FALSE 2022-01-01 00:53:44
#> 4     1            1          PokemonBDSP   FALSE 2022-01-01 01:28:25
#> 5     1            0            bootstrap   FALSE 2022-01-01 01:33:16
#> 6     1            1 minecraftsuggestions   FALSE 2022-01-01 01:45:44

#inspect the subreddits the data were posted too
reddit_data$subreddit
#>   [1] "longtail"              "undelete"              "theisle"              
#>   [4] "PokemonBDSP"           "bootstrap"             "minecraftsuggestions" 
#>   [7] "SubSimGPT2Interactive" "McrOne"                "NatureIsFuckingLit"   
#>  [10] "NatureIsFuckingLit"    "shortscarystories"     "McrOne"               
#>  [13] "SimbaKingdom"          "TheCrypticCompendium"  "shortscarystories"    
#>  [16] "Showerthoughts"        "oddlysatisfying"       "MadeMeSmile"          
#>  [19] "McrOne"                "NatureIsFuckingLit"    "ScentsAroma"          
#>  [22] "ScentsAroma"           "ScentsAroma"           "Whatcouldgowrong"     
#>  [25] "McrOne"                "kelowna"               "McrOne"               
#>  [28] "mildlysatisfying"      "itookapicture"         "Gameboy"              
#>  [31] "ForzaHorizon"          "CryptoArt"             "overlanding"          
#>  [34] "pokemon"               "HalloweenStories"      "TapTitans2"           
#>  [37] "Postcovidsymptoms"     "solar"                 "PokemonGOBattleLeague"
#>  [40] "KerbalSpaceProgram"    "ColeColleen"           "LegendsOfRuneterra"   
#>  [43] "DubaiJobs"             "dubai"                 "pokemontrades"        
#>  [46] "beats"                 "nature"                "itookapicture"        
#>  [49] "ShadowoftheColossus"   "tipofmytongue"         "natureisbeautiful"    
#>  [52] "HawaiiVisitors"        "Yagafanclub"           "Stepmania"            
#>  [55] "SonyAlpha"             "itookapicture"         "Sims4"                
#>  [58] "dankmemes"             "VictoriaBC"            "letstradepedals"      
#>  [61] "MushroomPorn"          "Wholesomenosleep"      "NatureIsFuckingLit"   
#>  [64] "tbatenovel"            "ForeverAloneDating"    "Waterfalls"           
#>  [67] "nature"                "Outdoors"              "itookapicture"        
#>  [70] "OMORI"                 "natureisbeautiful"     "HawaiiVisitors"       
#>  [73] "Yagafanclub"           "Stepmania"             "SonyAlpha"            
#>  [76] "itookapicture"         "Sims4"                 "dankmemes"            
#>  [79] "VictoriaBC"            "letstradepedals"       "MushroomPorn"         
#>  [82] "Wholesomenosleep"      "NatureIsFuckingLit"    "tbatenovel"           
#>  [85] "ForeverAloneDating"    "Waterfalls"            "nature"               
#>  [88] "Outdoors"              "itookapicture"         "OMORI"                
#>  [91] "hiking"                "natureisbeautiful"     "Art"                  
#>  [94] "Art"                   "FindingFennsGold"      "pokemontrades"        
#>  [97] "u_Unfair_Minute_3585"  "LandscapePhotography"  "TWDVR"                
#> [100] "DnDGreentext"          "r4r"                   "SMHauto"              
#> [103] "AutoNewspaper"         "nosleep"               "McrOne"               
#> [106] "Coursemetry"           "Damnthatsinteresting"  "gfaev"                
#> [109] "Damnthatsinteresting"  "McrOne"                "CrestedGecko"         
#> [112] "KingkillerChronicle"   "BrilliantDiamondSub"   "McrOne"               
#> [115] "ubisoft"               "GreenHell"             "fantasywriters"       
#> [118] "writingcirclejerk"     "AdvertiseYourVideos"   "FindBacklink"         
#> [121] "GetMoreViewsYT"        "PostYourYouTubeVideos" "ShareYoutubeVideos"   
#> [124] "YoutubeChannelSharing" "YouTube_startups"      "YoutubersCSGO"        
#> [127] "YoutubeShortVideos"    "YouTubeViewsSubs"      "fuseboxgames"         
#> [130] "paludarium"            "DestinyTheGame"        "nosleep"              
#> [133] "McrOne"                "niagarafallsontario"   "skyrim"               
#> [136] "pokemontrades"         "pcmasterrace"          "PokemonEmerald"       
#> [139] "PokemonGOBattleLeague" "TheCoolKidsClub"       "DecidingToBeBetter"   
#> [142] "pmp"                   "TrendingQuickTVnews"   "Vivarium"             
#> [145] "whatsthatbook"         "socalhiking"           "Austin"               
#> [148] "woodworking"           "HappyTrees"            "PokemonEmerald"       
#> [151] "pokemon"               "Minecraftbuilds"       "Minecraftbuilds"      
#> [154] "Waterfalls"            "EarthPorn"             "Minecraftbuilds"      
#> [157] "EarthPorn"             "hiking"                "ARK"                  
#> [160] "CleaningTips"          "paludarium"            "HeadphoneAdvice"      
#> [163] "PokemonBDSP"           "2007scape"             "canon"                
#> [166] "ArtDeco"               "Antiques"              "bassfishing"          
#> [169] "Fishing"               "eurovision"            "solotravel"           
#> [172] "naturephotography"     "iPhoneography"         "naturephotography"    
#> [175] "iPhoneography"         "Colombia"              "gopro"                
#> [178] "PokemonBDSP"           "newzealand"            "TwoDots"              
#> [181] "yuri_jp"               "delhi"                 "RandomActsofCards"    
#> [184] "youtubestartups"       "skyrim"                "VinylCollectors"      
#> [187] "AnimalCrossing"        "aaDnDforMe"            "skylanders"           
#> [190] "tappedout"             "lordhuron"             "RelaxingYoutubeVideos"
#> [193] "Relaxing"              "ICARUS"                "relaxation"           
#> [196] "playark"               "McrOne"                "CARROTweather"        
#> [199] "PanicAttack"           "McrOne"                "SmallYTChannel"       
#> [202] "Insta360"              "dungeondraft"          "Ruleshorror"          
#> [205] "LibraryofBabel"        "edmprodcirclejerk"     "MusicForConcentration"
#> [208] "ImaginaryArchitecture" "McrOne"                "roadtripnewengland"   
#> [211] "McrOne"                "SatisfactoryGame"      "pokemon"              
#> [214] "NatureIsFuckingLit"    "ZHouse_org"            "interestingasfuck"    
#> [217] "UnsentLetters"         "selfpromotion"         "u__tileman"           
#> [220] "cyprus"                "McrOne"                "BreakUps"             
#> [223] "LINKTrader"            "Chainlink"             "GameTheorists"        
#> [226] "SaltLakeCity"          "doomer"                "hiking"               
#> [229] "MostBeautiful"         "nationalparks"         "AdvertiseYourVideos"  
#> [232] "GetMoreViewsYT"        "YouTube_startups"      "Terrarium"            
#> [235] "videos"                "u_dirrtyremixes"       "scenedl"              
#> [238] "pics"                  "ShrugLifeSyndicate"    "BarbariansonNetflix"  
#> [241] "BarbariansonNetflix"   "starryai"              "itookapicture"        
#> [244] "amateurradio"          "oakland"               "BadLifeguard"         
#> [247] "Showerthoughts"        "kpopthoughts"          "whereisthis"          
#> [250] "itookapicture"         "TheOA"                 "audiomeditation"      
#> [253] "NoFeeAC"               "SatisfactoryGame"      "Avoidant"             
#> [256] "pokemon"               "audiomeditation"       "OnePiece"             
#> [259] "sleep"                 "NatureIsFuckingLit"    "Polestar"             
#> [262] "copypasta"             "TheKillers"            "EcoGlobalSurvival"    
#> [265] "Fantasy"               "shortscarystories"     "McrOne"               
#> [268] "NoStupidQuestions"     "Outdoors"              "McrOne"               
#> [271] "Genshin_Impact"        "McrOne"                "u_Tuckplumbing"       
#> [274] "VisitingIceland"       "McrOne"                "CharacterRant"        
#> [277] "ScarySigns"            "DestinyLore"           "DestinyLore"          
#> [280] "u_DONT_READ_THIS_OKAY" "RTLSDR"                "landscaping"          
#> [283] "ponds"                 "Wombodream"            "reddeadredemption"    
#> [286] "discgolf"              "u_Tuckplumbing"        "moronslookingatthings"
#> [289] "woodworking"           "news"                  "piano"                
#> [292] "itookapicture"         "gardening"             "PokemonBDSP"          
#> [295] "2007scape"             "admincraft"            "iPhoneography"        
#> [298] "polls"                 "u_RelaxTones"          "DiscGolfValley"       
#> [301] "minecraftseeds"        "piano"                 "interestingasfuck"    
#> [304] "interestingasfuck"     "interestingasfuck"     "CurseofStrahd"        
#> [307] "VRchat"                "Waterfalls"            "nosleep"              
#> [310] "AgonyGame"             "TheMonkeysPaw"         "StonerEngineering"    
#> [313] "pmp"                   "NatureIsFuckingLit"    "AutoNewspaper"        
#> [316] "u_RelaxTones"          "u_Honest-Interest741"  "PokemonSwordAndShield"
#> [319] "skyrim"                "HappyTrees"            "VGC"                  
#> [322] "pokemon"               "IttoMains"             "u_Dream_Infer2093"    
#> [325] "u_Smooth_Bear5820"     "Undertale"             "McrOne"               
#> [328] "Outdoors"              "Drugs"                 "Drugs"                
#> [331] "AllAboutNature"        "goodvibes"             "natureisbeautiful"    
#> [334] "natureporn"            "MinecraftCommands"     "u_KPAKA_tv"           
#> [337] "newzealand"            "Minecraft"             "u_ForkedAgain1"       
#> [340] "McrOne"                "videos"                "newzealand"           
#> [343] "AnimalCrossing"        "dndstories"            "McrOne"               
#> [346] "McrOne"                "HackyPixelz"           "u_Extremazon"         
#> [349] "u_mircea5533"          "audiomeditation"       "calmdown"             
#> [352] "calmingsounds"         "CalmingVideos"         "cantsleep"            
#> [355] "getdisciplined"        "u_tomey007"            "goodvibes"            
#> [358] "HealingMusic"          "landscaping"           "natureisbeautiful"    
#> [361] "natureporn"            "NatureRelax"           "neature"              
#> [364] "palatecleanser"        "PeacefulContent"       "cryptohours"          
#> [367] "relaxation"            "NationalPark"          "McrOne"               
#> [370] "2007scape"             "DealAndSale"           "AsianGuysSFW"         
#> [373] "Naruto"                "itookapicture"         "MostBeautiful"        
#> [376] "Yosemite"              "relaxation"            "Relaxing"             
#> [379] "RelaxingRoom"          "relaxingvideos"        "RelaxingYoutubeVideos"
#> [382] "Selfpromote"           "SleepMusic"            "SlowTV"               
#> [385] "stressrelief"          "Sub4Sub"               "YouTube_startups"     
#> [388] "YouTubeSubscribeBoost" "pokemon"               "ruralporn"            
#> [391] "ScentsAroma"           "NoStupidQuestions"     "Sims4"                
#> [394] "whatsthisrock"         "VinylCollectors"       "GiansFavorites"       
#> [397] "u_FairSeaweedQ"        "researchchemicals"     "vanmoofbicycle"       
#> [400] "entertainment"         "Bumble"                "stunfisk"             
#> [403] "FoodVlog"              "Undertale"             "u_Nelly38"            
#> [406] "pokemon"               "reactjs"               "halo"                 
#> [409] "photocritique"         "submechanophobia"      "frogs"                
#> [412] "newhampshire"          "ICARUS"                "SurviveIcarus"        
#> [415] "ThatsInsane"           "Plumbing"              "CRPS"                 
#> [418] "trees"                 "whatsthatbook"         "FreeWrite"            
#> [421] "PokemonBDSP"           "pics"                  "Minecraft"            
#> [424] "MakeNewFriendsHere"    "AussieMakeupTrade"     "istanbul"             
#> [427] "Outdoors"              "AussieMakeupTrade"     "GODUS"                
#> [430] "McrOne"                "paludarium"            "u_neyculro1991"       
#> [433] "videos"                "pics"                  "DrCreepensVault"      
#> [436] "Aquariums"             "McrOne"                "TikTok_Tits"          
#> [439] "Mosses"                "DarkSouls2"            "agile"                
#> [442] "videos"                "NatureIsFuckingLit"    "McrOne"               
#> [445] "VisitingIceland"       "DMT"                   "China"                
#> [448] "itookapicture"         "McrOne"                "PlanetZoo"            
#> [451] "u_DONT_READ_THIS_OKAY" "Genshin_Impact"        "RTLSDR"               
#> [454] "PlanetZoo"             "scarystories"          "McrOne"               
#> [457] "TheSilphArena"         "apexlegends"           "HamRadio"             
#> [460] "jewelry"               "orlando"               "LovecraftianWriting"  
#> [463] "stayawake"             "McKinney"              "Rolling_Line"         
#> [466] "amateurradio"          "SkyrimModsXbox"        "HimachalPradesh"      
#> [469] "himalayas"             "travelphotos"          "penspin"              
#> [472] "penspinning"           "pokemon"               "itookapicture"        
#> [475] "Waterfalls"            "HolUp"                 "pics"                 
#> [478] "Finland"               "deepdream"             "u_ChillaxingLlama"    
#> [481] "DetailCraft"           "Bishop"                "gaming"               
#> [484] "stories"               "Aquariums"             "KerbalSpaceProgram"   
#> [487] "pmp"                   "DMAcademy"             "Aquariums"            
#> [490] "SuicideWatch"          "weedgrower"            "drawing"              
#> [493] "MakeMeSuffer"          "DiscordAdvertising"    "MakeMeSuffer"         
#> [496] "assassinscreed"        "pokemon"               "drones"               
#> [499] "HydroHomies"           "AnimalCrossingNewHor"  "GamblingAddiction"    
#> [502] "centralcalhiking"      "Undertale"             "VGC"                  
#> [505] "u_ForkedAgain1"        "RS3Ironmen"            "MysteryDungeon"       
#> [508] "Jigsawpuzzles"         "KeepWriting"           "Actualshowerthoughts" 
#> [511] "KeepWriting"           "McrOne"                "Minecraft"            
#> [514] "BeAmazed"              "gameassets"            "AMA"                  
#> [517] "u_Veekends"            "tradinghome"           "McrOne"               
#> [520] "tifu"                  "u_ThinExplanation2678" "nosleep"              
#> [523] "PhoenixSC"             "aww"                   "aww"                  
#> [526] "oddlysatisfying"       "u_Kjohn28"             "McrOne"               
#> [529] "FFXV"                  "FluentInFinance"       "wallstreetbets"       
#> [532] "wallstreetbets"        "McrOne"                "Waterfalls"           
#> [535] "cryptids"              "stunfisk"              "relationship_advice"  
#> [538] "u_Indglobal_in"        "forgeofempires"        "McrOne"               
#> [541] "Cornell"               "NatureIsFuckingLit"    "apexlegends"          
#> [544] "Gilbert"               "Waterfalls"            "ApexVideos"           
#> [547] "phoenix"               "OPZuser"               "opz"                  
#> [550] "OnePiece"              "babies"                "RainbowEverything"    
#> [553] "duck"                  "PersonalBasicIncome"   "BDSPCompetitive"      
#> [556] "mademehappycry"        "DrCreepensVault"       "FujifilmX"            
#> [559] "u_Saudinews2020"       "MadeMeSmile"           "indepthstories"       
#> [562] "u_jackie4CHANsenpai"   "techsupport"           "djimavicmini"         
#> [565] "holamoncat"            "TheSilphArena"         "trees"                
#> [568] "BabiesReactingToStuff" "u_mangomae"            "BabiesReactingToStuff"
#> [571] "Koi"                   "Undertale"             "ScarySigns"           
#> [574] "u_InevitableyCannon"   "nosleep"               "DidntKnowIWantedThat" 
#> [577] "youseeingthisshit"     "youseeingthisshit"     "u_BeTvOfficiel"       
#> [580] "NatureIsFuckingLit"    "UFOs"                  "PokemonBDSP"          
#> [583] "gaming"                "reddeadredemption"     "RedDeadOnline"        
#> [586] "PS4"                   "shittyaskscience"      "projectmanagement"    
#> [589] "MadeMeSmile"           "neverallowedtopost"    "wow"                  
#> [592] "Deltarune"             "NextTopModelPhotos"    "aww"                  
#> [595] "BabiesReactingToStuff" "KerbalSpaceProgram"    "DiscoverEarth"        
#> [598] "u_Honest-Interest741"  "CryptidsRoostsDungeon" "TearsOfThemis"        
#> [601] "PokemonTCG"            "cryosleep"             "u_Mr_StingJr"
```

From inspecting the data we can see that quite a lot of these posts were
not to subreddits relevant for landscape scale studies. Instead lets
check out a specific subreddit of interest: “r/EarthPorn”. Lets take a
quick look at posts to EarthPorn, by returning all posts there for one
day.

``` r
reddit_data <- reddit_search(subreddit = "EarthPorn",
                             start_date = "2022-01-01",
                             end_date = "2022-01-02")
#inspect data
head(reddit_data)[-1] 
```

Now posts to this subreddit should all be photographs. One neat thing we
can do with this is download the images for further inspection or
analysis. In the next line of code everyone will download a random image
from the returned data set to have a look at. First, everyone will
generate a random number between 1 and the number of images returned. We
will then use that number to downloaded the image in that row number.

``` r
#this code says, generate a random number, between 1, and the maximum number of rows in our data
number <- sample(1:nrow(reddit_data), 1)

#here we select the URL of the image that we want to download
file_url <- reddit_data$url[number]

#here we download the file and save it in your current working directory with the name earthporn.jpg
download.file(file_url, 'earthporn.jpg', mode = 'wb') 
```

When downloading images, please check back with the original post to
ensure you are not infringing on any copyright or privacy policy. To
ensure we aren’t doing that we can just delete the photograph for now.

``` r
file.remove('earthporn.jpg')
```

It is also possible to search for a specific term within a subreddit.
Here, I am going to search for images in EarthPorn with the text,
“Wales”.

``` r
reddit_data <- reddit_search(search_term = "wales",
                             subreddit = "EarthPorn",
                             start_date = "2020-01-01",
                             end_date = "2022-01-01") 
#inspect data
head(reddit_data)[-1] 
```

## Sentiment dictionaries

Textual sentiment analysis assess the emotion expressed within a piece
of text. This can be a powerful tool in understanding how people feel
about the natural environment. As with previous task we need to download
and library the necessary packages to perform these analysis.

The most basic textual sentiment analysis is performed by comparing
words to a pre-defined dictionary. These dictionaries have been created
by other researchers who manually attributed a value to the sentiment of
individual word. Today we will look at three dictionaries AFINN, bing
and ncr.

First, the AFINN dictionary [(Nielsen
2011)](https://arxiv.org/abs/1103.2903) ranks words on a scale of -5 to
+5. Words negatively ranked are those with a negative associated
sentiment and those with a positive rank are associated with a positive
sentiment. While the number represents the magnitude of sentiment (e.g.,
+5 is more positive than +3).

``` r
tidytext::get_sentiments("afinn")
#> # A tibble: 2,477 × 2
#>    word       value
#>    <chr>      <dbl>
#>  1 abandon       -2
#>  2 abandoned     -2
#>  3 abandons      -2
#>  4 abducted      -2
#>  5 abduction     -2
#>  6 abductions    -2
#>  7 abhor         -3
#>  8 abhorred      -3
#>  9 abhorrent     -3
#> 10 abhors        -3
#> # … with 2,467 more rows
```

Second, the bing dictionary [Liu et
al. ](https://www.morganclaypool.com/doi/abs/10.2200/s00416ed1v01y201204hlt016?casa_token=zVb-dykzCngAAAAA:joawB4fnvH6TWALFJeKJS8HiQQ07g920cdnjogMvSesova-GyXExeT7wwFkW2C6XjppwyThDHA)
ranks word in a binary fashion of either positive of negative.

``` r
tidytext::get_sentiments("bing")
#> # A tibble: 6,786 × 2
#>    word        sentiment
#>    <chr>       <chr>    
#>  1 2-faces     negative 
#>  2 abnormal    negative 
#>  3 abolish     negative 
#>  4 abominable  negative 
#>  5 abominably  negative 
#>  6 abominate   negative 
#>  7 abomination negative 
#>  8 abort       negative 
#>  9 aborted     negative 
#> 10 aborts      negative 
#> # … with 6,776 more rows
```

Third, the nrc dictionary [Mohammad and Turney
2010,](https://arxiv.org/pdf/1308.6297.pdf) categories word into
different emotions: positive, negative, anger, anticipation, disgust,
fear, joy, sadness, surprise, and trust.

``` r
tidytext::get_sentiments("nrc")
#> # A tibble: 13,872 × 2
#>    word        sentiment
#>    <chr>       <chr>    
#>  1 abacus      trust    
#>  2 abandon     fear     
#>  3 abandon     negative 
#>  4 abandon     sadness  
#>  5 abandoned   anger    
#>  6 abandoned   fear     
#>  7 abandoned   negative 
#>  8 abandoned   sadness  
#>  9 abandonment anger    
#> 10 abandonment fear     
#> # … with 13,862 more rows
```

You may have noticed, not only do these dictionaries have different
methods of measuring sentiment, they also have a different number of
categorized words. This makes each dictionary good for different
purposes. It has been demonstrated that AFINN is a good dictionary for
evaluating social media data, so lets focus on that for now.

## Finding the sentiment of social media posts

For the purpose of this demonstration I have scripted some useful
functions that quickly let us organize and assess the sentiment of posts
from Flickr. The `paste2()` function allows you to easily paste multiple
column together without including NAs or missing data, while the
`flickr_afinn()` and `flickr_nrc()` functions quickly let you add an
additional column(s) to our data frames that summaries the sentiment
scores.

If you are interested in seeing how these functions work they are listed
under the R folder in the `helpful_functions.R` file.

``` r
#search flickr for posts containing the word "nature" in a give place and time
flickr_raw <- photo_search(mindate_taken = "2021-01-01",
                           maxdate_taken = "2021-01-07",
                           bbox = "-134.648443,21.398553,-54.140630,49.925909",
                           text = "tree")

#here we create a new column called text and paste in all the other text from that row
flickr_raw$text <- paste2(flickr_raw$title,
                          flickr_raw$description,
                          flickr_raw$tags)

#use our custom function to add afinn sentiments to the
flickr_afinn <- flickr_afinn(flickr_data = flickr_raw)

#use our custom function to add nrc sentiments to the
flickr_nrc <- flickr_nrc(flickr_data = flickr_raw)
```

## Making spatial maps

One of the next things we can do is use the sentiment data to map areas
of high and low sentiment. In this basic example we will map a few
points labeled as hiking on Flickr in the United Kingdom and map which
areas have high and low sentiment.

``` r
library(rnaturalearth)
library(rnaturalearthdata)
library(photosearcher)
library(ggplot2)
library(seasHackathon)
library(dplyr)
library(tidytext)
#> Warning: package 'tidytext' was built under R version 4.2.2

#search flickr for posts containing the word "nature" in a give place and time
flickr_raw <- photo_search(mindate_taken = "2021-01-01",
                           maxdate_taken = "2021-01-07",
                           bbox = "-11.250000,50.035974,1.757813,59.844815",
                           text = "hiking")

#here we create a new column called text and paste in all the other text from that row
flickr_raw$text <- paste2(flickr_raw$title,
                          flickr_raw$description,
                          flickr_raw$tags)

#use our custom function to add afinn sentiments to the
flickr_afinn <- flickr_afinn(flickr_data = flickr_raw)
#> Joining, by = "word"

#create a simple base map
world <- ne_countries(scale = "medium", returnclass = "sf")

#plot the data
ggplot() + 
  geom_sf(data = world, color = "black", fill = "white") + #plot base map
  coord_sf(xlim = c(-11.250000,1.757813), ylim = c(50.035974,59.844815), expand = FALSE) + #zoom to bbox
  geom_point(data = flickr_afinn, aes(x = longitude, y = latitude, color = afinn_sentiment)) #plot points
```

<img src="man/figures/README-make maps-1.png" width="100%" />

## Mapping social interactions

Here we are going to use some functions from the
[RedditExtractor](https://github.com/ivan-rivera/RedditExtractor)
package. `RedditExtractor` has a function called `get_reddit` which
provides similar functionality to the `reddit_search()` we just used
from `photosearcher`. The `get_reddit()` function returns data in a
slightly different way, which may not be user friendly, however the
function has the added ability to specify a minimum number of comments.
Using this additional variable we can find posts that have a large
number of comments and therefore discussion around landscape or
ecological features. Unfortunately, an update to the package got rid of
this function so we will have to download an older version to access
this feature.

``` r
#needed for mac users
install.packages(c('devtools','curl'),
                 repos = "http://cran.us.r-project.org") 
require(devtools)
install_version("RedditExtractoR", version = "2.1.5", repos = "http://cran.us.r-project.org")
```

``` r
library("RedditExtractoR")
```

Here we use this older code to return posts discussing the grand canyon
from EarthPorn with more than 500 comments. Feel free to change this to
any search that you are interested in!

``` r
reddit_content <- get_reddit(
  search_terms = "Grand Canyon",
  subreddit = "EarthPorn",
  cn_threshold = 500
)
```

Once we have this data stored we can generate network maps of
interactions between users.

``` r
#large networks take long to generate so here we take the first 200 comments
reddit_content <- reddit_content[1:200,] 
#extract the information needed for the plot
user <- user_network(reddit_content, 
                     include_author = FALSE, 
                     agg = TRUE)
#plot the network
user$plot
```

## Over to you

Now that we have covered the basics, your goal for the day is to come up
with an execute a suitable research aim that uses social media text to
find and assess environmental attitudes. I have some suggestions of
interesting topics below, but the main goal of the day is to have fun
and learn new skills, so pick a topic that interests you most.

-Opinions on different animal species?

-Favorite recreational activities?

-Attitude towards the sustainable development goals?

-Preferences for more sustainable food options?

-Discussion on environmental disasters?

-How different elements of nature makes people feel?
