//  Utility.m
//  The Life
//
//  Created by AQB Solutions-Mac Mini 2 on 09/06/2016.
//  Copyright (c) 2016 AQB Solutions-Mac MacBookAir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Calorie.h"
#import "AMPopTip.h"   //ah ov
#import "CustomAlertViewController.h"
#import "Reachability.h"
#import "CustomNavigation.h"
#import "GratitudeListViewController.h"
@import Firebase;


typedef NS_ENUM(int, ActualMealType) {
    SqMeal = 1,
    SqIngredient = 2,
    Nutritionix = 3,
    Quick = 4
};

typedef NS_ENUM(int, QuestionType) {
    COHENSTRESS = 1,
    RAHEPERCEIVED = 2,
    HAPPINESS = 3,
    SLEEPRATING = 4,
    DASS = 5,
    IBS = 6
};

typedef NS_ENUM(int, QuestionStatusType) {
    INPROCESS = 1,
    COMPLETED = 2
    
};

typedef NS_ENUM(int, SessionType) {
    FOLLOWALONG = 1,
    TIMER = 5,
    CIRCUITTIMER = 6
};


typedef NS_ENUM(int, DeviceType) {
    Fitbit = 1,
    Garmin = 2,
    Jawbone = 3,
    IWatch = 4
};
typedef NS_ENUM(int, CalorieConstants) {
    CaloriePerCarbGram = 4,
    CaloriePerProteinGram = 4,
    CaloriePerFatGram = 9,
    CaloriePerAlcoholGram = 7
};
typedef NS_ENUM(int,FitbitdataType){
    Calories = 1,
    Distance = 2,
    HrExecutive = 3,
    HrNormal = 4,
    HrResting = 5,
    VeryActiveMinutes = 6,
    FairlyActiveMinutes = 7,
    LightlyActiveMinutes = 8,
    Sleep = 9,
    Water = 10,
    Step=11
};
typedef NS_ENUM(int, SignupVia) {
    Web = 0,
    IOS = 1,
    Android = 2,
    Shopify = 3
};
typedef NS_ENUM(int,ingredientType){
    SquadIngredient=1,
    MyIngredient=2,
    AllIngredient=3
};
typedef NS_ENUM(int,ExerciseSessionType){
    Weights = 1,
    HIIT = 2,
    Pilates = 3,
    Yoga = 4,
    Cardio = 5,
    CardioBasedClass = 6,
    ResistanceBasedClass = 7,
    Sport = 8,
    FBW = 9
};
typedef NS_ENUM(int,ExerciseBodyType){
    FullBody = 1,
    LowerBody = 2,
    UpperBody = 3,
    Core = 4
};

typedef NS_ENUM(int,SubscriptionType){
    Free = 0,
    MemberOnly = 1,
    Paid = 2,
    
};

typedef NS_ENUM(int,PublishType){
    Seminar = 1,
    Message = 2
};
typedef NS_ENUM(int,HabitStatusType){
    All = 0,
    Active = 1,
    Completed = 2,
    Snooze = 3
};
typedef NS_ENUM(int,BucketListStatus){
    BucketHidden = 0,
    BucketActive = 1,
    BucketCompleted = 2,
   
};
typedef NS_ENUM(int,UploadUniqueMbhqImageStatus){
    VisionBoard = 1,
    BucketList = 2,
    ReverseBucketList = 3,
    GratitudeList = 4,
    VisionStatement = 5
};
#define DBNAME @"SquadDB" //AY 20022018
#define BASEPASSWORD_FIREBASEAUTH @"#@%$&^*#&^*#&^*#"
#define BASEPASSWORD_COMMUNITY @"forumuser@"
#define UPGRADEBASEURL @"https://mindbodyhq.com"
#define APPSTORE_URL @"https://itunes.apple.com/us/app/ashy-bines-squad/id1202514525?ls=1&mt=8"
#define PRIVACY_POLICY_URL @"https://mindbodyhq.com/pages/t-and-c"
#define SHOWME_HABIT_URL @"https://squad-live.s3-ap-southeast-2.amazonaws.com/MbHQ+Happiness+Habit/Habit_change_examples.pdf"
#define HELP_MENU @"https://squad-live.s3-ap-southeast-2.amazonaws.com/MbHQ+Happiness+Habit/Mbhq_help.pdf"
#define VISION_INFO @"https://squad-live.s3-ap-southeast-2.amazonaws.com/MbHQ+Happiness+Habit/Vision_board.pdf"
#define CANCEL_SUBSCRIPTION_LINK @"https://mindbodyhq.com/tools/recurring/get-subscription-access#/"
#define PURCHASE_MASK_URL @"https://mindbodyhq.com/meditationmask"
#define TEST_LEVEL_URL @"https://meditate.mindbodyhq.com"
//#define APPSTORE_RECEIPT_URL @"https://sandbox.itunes.apple.com/verifyReceipt"
#define APPSTORE_RECEIPT_URL @"https://buy.itunes.apple.com/verifyReceipt"


//TODO: Video/Audio Download URL
#define BASE_VIDEO_DOWNLOAD_URL @"https://s3-ap-southeast-2.amazonaws.com/squad-live/exercise-videos/mini/"
#define BASE_AUDIO_DOWNLOAD_URL @"https://s3-ap-southeast-2.amazonaws.com/squad-live/exercise-audio/"

//TODO: End

//TODO: Nutritionix URL
#define NutritionixURL @"http://trackapi.nutritionix.com/v2"
#define Nutr_app_id @"02535a56"
#define Nutr_app_key @"1f7821557b5ac41fdcdb6a35d170ff50"

//TODO: End 

//TODO: Development Server
//#define BASEURL_ABBBC   @"http://dev1abbbcapi.thesquadtours.com"
//#define BASEURL   @"http://dev1.thesquadtours.com"
//#define BASEIMAGE_URL @"http://dev1.thesquadtours.com/Images/Members/"
//#define BASEVIDEOURL @"http://dev1.thesquadtours.com/Content/Video/"
//#define BASEGAMIFICATIONIMAGE_URL @"http://dev1.thesquadtours.com/content/Images/Profilesquad/"

// NEED TO CHANGE THE VALU FOE LIVE
#define WEBINAR_EVENT_TYPE  [NSNumber numberWithInt:20]
//TODO: End

//TODO: Live Server'
#define BASEURL_ABBBC   @"https://abbbcapi.thesquadtours.com"
#define BASEURL   @"https://www.thesquadtours.com"
#define BASEIMAGE_URL @"https://www.thesquadtours.com/Images/Members/"
#define BASEVIDEOURL @"https://www.thesquadtours.com/Content/Video/"
#define BASEGAMIFICATIONIMAGE_URL @"https://www.thesquadtours.com/content/Images/Profilesquad/"
//TODO: End

//TODO: New Server
//#define BASEURL_ABBBC   @"http://abbbcapi.softways.in"
//#define BASEURL   @"https://squad.softways.in"
//#define BASEIMAGE_URL @"https://squad.softways.in/Images/Members/"
//#define BASEVIDEOURL @"https://squad.softways.in/Content/Video/"
//#define BASEGAMIFICATIONIMAGE_URL @"https://squad.softways.in/content/Images/Profilesquad/"
//TODO: End

//TODO: Local System Server
//#define  BASEURL   @"http://192.168.10.139:52959"
////#define  BASEURL_ABBBC   @"http://dev1api.abbbconline.com"
//#define  BASEURL_ABBBC   @"http://192.168.10.139/ABBBC.API/"
//#define BASEIMAGE_URL @"http://192.168.10.139:52959/Images/Members/"
//#define BASEVIDEOURL @"http://192.168.10.139:52959/Content/Video/"
//TODO: End

#define deepLinksHosts @[@"squaddaily",@"dailygoodness",@"fatloss",@"mealplan",@"customexercise",@"challenge",@"fitbit_iwatch",@"fbw_tracker",@"session_list",@"calorie_counter",@"food_prep_helper",@"recipes_list",@"courses",@"eight_week_challenge",@"set_programs",@"webinar_all",@"find_a_friend",@"message_center",@"accountability_buddies",@"goals_vision",@"vision_board",@"bucket_list",@"personal_challenge",@"meditation",@"gratitude_list",@"photos",@"weigh_ins",@"questionnaire",@"gamification_centre",@"booty_abs",@"calendar",@"settings",@"web",@"today_page",@"help",@"BucketList",@"Goal"]


#define ChatCreationError @"Unable to create chat thread as user does not have the latest version of the app"
#define  YOUTUBECHANNELURL    @"https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCsJg7i0b0U9xQ66gmUTXDiQ&key=AIzaSyDE7z84dC2r-Nd2IcWSniKsUji_vWSmL3Q&maxResults=50"

#define YOUTUBEPLAYLISTURL @"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key=AIzaSyDE7z84dC2r-Nd2IcWSniKsUji_vWSmL3Q&maxResults=50&playlistId="
#define  AccessKey  @"5CDAAEC0BCA74C70BF2FFA3E4B4E963E"
#define  CommunityServerKey  @"bc7ffc2314225976c01dbf88ab88287e"
#define  AccessKey_ABBBC  @"1234"  //ah 17
#define CHALLENGE_ID @"4TuGo"
#define CHALLENGE_ID_REGISTERED @"TuN9a"
//#define BASEURL_GETRESPONSE  @"https://api3.getresponse360.pl/v3"
#define BASEURL_GETRESPONSE  @"https://a.klaviyo.com/api/v2/list/MU78Rt/members?api_key=pk_0868fc3492c992a6014ba2c67227636404"//pk_67aef000b1a5b291c885ee23c4520e79e4
#define API_TOKEN @"api-key 9dd0796ed70d97b0d732cc97f9c35d3a"
#define X_DOMAIN @"ashysquadtour.com"
#define FOOD_SCAN_API @"https://api.edamam.com/api/food-database"
#define FOOD_SCAN_APP_ID @"cce4a0b3"
#define FOOD_SCAN_APP_KEY @"ae73d3cedf2c6516cbbf2a14969435f5"
#define BlueBadgeColor @"93E2DD" //chnage_rewards
#define ShedBadgeBule  @"def6f6"
#define mbhqBaseColor @"32cdb8"

//#define  BASEURL   @"http://devthelife.com//Images/Members/"
//#define BASEVIDEOURL @"http://dev1.thesquadtours.com/Content/Video/"

#define starImageArray @[@"star1gamification.png",@"star2gamification.png",@"star3gamification.png",@"star4gamification.png",@"star5gamification.png",@"star6gamification.png",@"star7gamification.png",@"star8gamification.png",@"star9gamification.png",@"star10gamification.png",@"star11gamification.png",@"star12gamification.png",@"star13gamification.png",@"star14gamification.png",@"star15gamification.png"]

#define notAllowedWithoutTrailLoginArray  @[@"CustomNutritionPlanListViewController",@"ShoppingListViewController",@"ChalengesHomeViewController",@"BlankListViewController",@"MealMatchViewController",@"AddEditIngredientViewController",@"AddEditCustomNutritionViewController",@"AddRecipeViewController",@"FitnessTrackerViewController",@"TrackMiddleViewController",@"EditCircuitViewController",@"CreateCircuitViewController",@"CreateSessionViewController",@"EditExerciseSessionViewController",@"CourseDetailsViewController",@"MyWatchListViewController",@"AudioBookViewController",@"FoodPrepViewController"]
#define  defaults    [NSUserDefaults standardUserDefaults]
#define feelType  @{@1:@"Tighter",@2:@"Looser",@3:@"The Same",@4:@"Start Reference"}
#define feelTypeArray @[@{@"key":@1,@"value":@"Tighter"},@{@"key":@2,@"value":@"Looser"},@{@"key":@3,@"value":@"The Same"},@{@"key":@4,@"value":@"Start Reference"}]
#define VegetarianType  @{@"Other":@1,@"Lacto_Ovo":@2,@"Vegan":@3,@"Pescatarian":@4}

//@[@"I am proud of",@"I've accomplished",@"I've observed",@"I've learned",@"I've praised",@"Today I've let go of",@"I dreamt of",@"Journal Entry"]
//#define growthOptionArr @[@"Journal Entry",@"Today I'm Feeling",@"The story I've told myself is",@"I am proud of",@"I've accomplished",@"I've been challenged by",@"A small win I'm celebrating is",@"I've observed",@"I've learned",@"I laughed",@"I've praised",@"I've let go of",@"I dreamt of"]

#define growthOptionArr @[@"I’m Grateful For",@"Journal Entry",@"Prompt of the Day",@" ",@"Today I'm Feeling",@"I am proud of",@"I've accomplished",@"I'm working towards",@"I'm feeling growth in",@"I’m committing to",@"A small win I'm celebrating is",@"I've found the gift in",@"I felt happy today because",@" ",@"The story I've told myself is",@"I've been challenged by",@"I've observed",@"I've learned",@"I acknowledge",@"I laughed",@"I've praised",@"I've let go of",@"I dreamt of"]

//#define growthOptionArrForJournal @[@[@"I’m Grateful For",@"Journal Entry",@"Prompt of the Day"],@[@"Today I'm Feeling",@"I am proud of",@"I've accomplished",@"I'm working towards",@"I'm feeling growth in",@"I’m committing to",@"A small win I'm celebrating is",@"I've found the gift in",@"I felt happy today because"],@[@"The story I've told myself is",@"I've been challenged by",@"I've observed",@"I've learned",@"I acknowledge",@"I laughed",@"I've praised",@"I've let go of",@"I dreamt of"]]

#define blankTypeArray @[@{@"key":@0,@"value":@"All"},@{@"key":@1,@"value":@"Done It"},@{@"key":@2,@"value":@"Still ToDO"}]
#define serveArray @[@{@"key":@1,@"value":@"1 Serve"},@{@"key":@2,@"value":@"2 Serves"},@{@"key":@3,@"value":@"3 Serves"},@{@"key":@4,@"value":@"4 Serves"},@{@"key":@5,@"value":@"5 Serves"},@{@"key":@6,@"value":@"6 Serves"},@{@"key":@7,@"value":@"7 Serves"},@{@"key":@8,@"value":@"8 Serves"},@{@"key":@9,@"value":@"9 Serves"},@{@"key":@10,@"value":@"10 Serves"}]

#define fitbitCategoryArray @[@{@"name":@"Steps",@"logo_image_name":@"fitbit_catagory_steps.png",@"ActivityType":@11,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_steps.png",@"ActivityType":@11,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_steps.png",@"ActivityType":@11,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_steps.png",@"ActivityType":@11,@"Day":@30,@"AverageDay":@30},@{@"name":@"Calories",@"logo_image_name":@"fitbit_catagory_calories.png",@"logo_image_name":@"fitbit_catagory_calories.png",@"ActivityType":@1,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_calories.png",@"ActivityType":@1,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_calories.png",@"ActivityType":@1,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_calories.png",@"ActivityType":@1,@"Day":@30,@"AverageDay":@30},@{@"name":@"Distance",@"logo_image_name":@"fitbit_catagory_distance.png",@"ActivityType":@2,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_distance.png",@"ActivityType":@2,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_distance.png",@"ActivityType":@2,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_distance.png",@"ActivityType":@2,@"Day":@30,@"AverageDay":@30},@{@"name":@"Sleep",@"logo_image_name":@"fitbit_catagory_sleep.png",@"ActivityType":@9,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_sleep.png",@"ActivityType":@9,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_sleep.png",@"ActivityType":@9,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_sleep.png",@"ActivityType":@9,@"Day":@30,@"AverageDay":@30},@{@"name":@"Water",@"logo_image_name":@"fitbit_catagory_water.png",@"ActivityType":@10,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_water.png",@"ActivityType":@10,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_water.png",@"ActivityType":@10,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_water.png",@"ActivityType":@10,@"Day":@30,@"AverageDay":@30},@{@"name":@"Active Minutes",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@6,@"Day":@0,@"AverageDay":@0},@{@"name":@"-This Week",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@6,@"Day":@6,@"AverageDay":@0},@{@"name":@"-Weekly Average",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@6,@"Day":@6,@"AverageDay":@7},@{@"name":@"-Monthly  Average",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@6,@"Day":@30,@"AverageDay":@30}]


#define fitbitFilterCategoryArray @[@{@"name":@"Steps",@"logo_image_name":@"fitbit_catagory_steps.png",@"ActivityType":@11,@"Day":@0,@"AverageDay":@0},@{@"name":@"Calories",@"logo_image_name":@"fitbit_catagory_calories.png",@"logo_image_name":@"fitbit_catagory_calories.png",@"ActivityType":@1,@"Day":@0,@"AverageDay":@0},@{@"name":@"Distance",@"logo_image_name":@"fitbit_catagory_distance.png",@"ActivityType":@2,@"Day":@0,@"AverageDay":@0},@{@"name":@"Water",@"logo_image_name":@"fitbit_catagory_water.png",@"ActivityType":@10,@"Day":@0,@"AverageDay":@0},@{@"name":@"Active Minutes",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@6,@"Day":@0,@"AverageDay":@0},@{@"name":@"Heart Rate",@"logo_image_name":@"fitbit_catagory_minutes.png",@"ActivityType":@3,@"Day":@0,@"AverageDay":@0}]

#define MERCHANT_ID @""
#define SHOP_DOMAIN @"ashy-bines.myshopify.com"
#define API_KEY @"59c977962352b9417400255a02479d59"
#define APP_ID @"8"
#define jsonEquip  @"[\"ab wheel\",\"ankle strap\",\"attachment\",\"barbell\",\"battle ropes\",\"bench\",\"bench (low height)\",\"bench or step (low height)\",\"bench press\",\"bench x 2 or\",\"bicep curl machine\",\"bike\",\"bosu\",\"bosu or fitball\",\"box\",\"boxing bag\",\"boxing gloves\",\"cable machine\",\"cable machine with attachment\",\"chin bar\",\"chin up bar\",\"core\",\"decline bench\",\"dip bar\",\"dumbbell\",\"dumbbells\",\"fitball\",\"foam roller\",\"ghr\",\"ghr machine, or ladder barrel\",\"gym machines\",\"kettlebell\",\"ladder barrer\",\"lat pull down\",\"leg press\",\"machine\",\"med ball\",\"med ball or weight to hold is optional\",\"medicine ball\",\"plate weights\",\"plates\",\"plyobox\",\"plyobox, or step up\",\"resistance band\",\"rope accessory\",\"rowing machine\",\"seated row\",\"shoulder press\",\"skipping rope\",\"slam ball\",\"slamball\",\"sleds\",\"smith machine\",\"smith machine or hook for band\",\"step\",\"step x 2\",\"strap\",\"suspension training straps\",\"torsonator\",\"towel\",\"treadmill\",\"wall to lean against\",\"weight plates\",\"weights\"]"

/*
 
 
 */
#define jsonTags @"[\"Abductor\",\"Adductor\",\"Advanced\",\"Arm Circles\",\"Back\",\"Back Extension\",\"Balance\",\"Ballistic\",\"Barbell\",\"Battle Ropes\",\"Bear Walks\",\"Bench Press\",\"Bent Over Row\",\"Biceps\",\"Bike\",\"Booty\",\"Box Jumps\",\"Boxing\",\"Burn\",\"Burpee\",\"Butt Extension\",\"Butt Raise\",\"Cables\",\"Calf Raise\",\"Can Cans\",\"Cardio\",\"Chest\",\"Chest Press\",\"Chin Ups\",\"Clams\",\"CleanandJerk\",\"Cool Down\",\"Core\",\"Cross Over\",\"Crossfit\",\"Crunch\",\"Deadlift\",\"Deltoids\",\"Dip\",\"Dumbbell\",\"Dumbbell Press\",\"Dynamic Warm Up\",\"Endurance\",\"Explosive\",\"Farmers Walk\",\"Fitball\",\"Foam Roller\",\"Functional\",\"Functional Fitness\",\"GHR\",\"Glutes\",\"Hamstrings\",\"High Knees\",\"Hold\",\"Hussles\",\"Incline Press\",\"Isometric\",\"Jogging\",\"Kettlebells\",\"Kicksit\",\"Lat Pulldown\",\"Lateral Hops\",\"Lateral Raise\",\"Leg Extension\",\"Leg Press\",\"Leg Raise\",\"Lunge\",\"Lunge: Front Foot Elevated with Dumbbell\",\"Medicine Ball\",\"Mountain Climbers\",\"OlympicLifts\",\"Pec\",\"Pec Fly\",\"Pilates\",\"pilates ring\",\"Plank\",\"Posterior Chain\",\"Posterior Delt\",\"Pulse\",\"Pulsing\",\"Push Up\",\"Quads\",\"Recovery\",\"Rehab\",\"Resistance band\",\"rest\",\"Row\",\"Rower\",\"Seated Row\",\"Shoulders\",\"Shuttles\",\"Single Arm\",\"Sit Up\",\"Skipping\",\"Slam Ball\",\"sleds\",\"Smith Machine\",\"Snatch\",\"Split Squat\",\"Squad Straps\",\"Squat\",\"Squat Jump\",\"Star Jump\",\"Step Up\",\"Stretch\",\"Superman\",\"Swing\",\"Torsonator\",\"Total Hip\",\"Treadmills\",\"Tricep\",\"Tuck Jumps\",\"Turkish Get Up\",\"Upper Body\",\"V-Sit\",\"Walk\",\"Warm Up\",\"Wide Grip\",\"Wide Leg\",\"Yoga\"]"

//#define OldjsonTags  @"[\"abductor\",\"adductor\",\"adductors\",\"advanced\",\"arm circles\",\"back\",\"back extension\",\"balance\",\"ballistic\",\"bar\",\"barbell\",\"battle ropes\",\"bear walks\",\"bench\",\"bench press\",\"bent over row\",\"bicep\",\"biceps\",\"bike\",\"box jumps\",\"boxing\",\"burn\",\"burpee\",\"butt extension\",\"butt raise\",\"cable\",\"cable machine\",\"cables\",\"calf raise\",\"can cans\",\"cardio\",\"chest\",\"chest press\",\"chin ups\",\"clams\",\"core\",\"cross over\",\"crossfit\",\"crunch\",\"deadlift\",\"deltoids\",\"dip\",\"dips\",\"dumbbell\",\"dumbbell press\",\"dumbbells\",\"dumbells\",\"dynamic warm up\",\"endurance\",\"explosive\",\"farmers walk\",\"fitball\",\"foam roller\",\"form\",\"functional\",\"functional fitness\",\"ghr\",\"glute bridge\",\"glutes\",\"hamstrings\",\"high knees\",\"hold\",\"how to\",\"hussles\",\"incline press\",\"instruction\",\"isometric\",\"jogging\",\"jumping\",\"kettle bell\",\"kettlebells\",\"lat pull down\",\"lat pulldown\",\"lateral hops\",\"lateral raise\",\"lats\",\"leg extension\",\"leg press\",\"leg raise\",\"lunge\",\"medicine ball\",\"mountain climbers\",\"obliques\",\"pec\",\"pec fly\",\"pilates\",\"pilates ring\",\"plank\",\"posterior chain\",\"posterior delt\",\"posteriorchain\",\"pulse\",\"pulsing\",\"push up\",\"quads\",\"recovery\",\"rehab\",\"rest\",\"reverse lunge\",\"romanian\",\"row\",\"rower\",\"seated row\",\"shoulders\",\"shuffle jumps\",\"shuttles\",\"single arm\",\"single leg\",\"sit up\",\"skipping\",\"sleds\",\"smith machine\",\"smithmachine\",\"split squat\",\"squat\",\"squat jump\",\"star jump\",\"star jumps\",\"step up\",\"step ups\",\"stretch\",\"superman\",\"suspension training\",\"swing\",\"torsonator\",\"total hip\",\"treadmills\",\"tricep\",\"triceps\",\"tuck jumps\",\"turkish get up\",\"walk\",\"wide\",\"wide grip\",\"wide leg\",\"yoga\"]"
#define  numberFormatter    [[NSNumberFormatter alloc] init]    //arnab new

#define musicListTypeArray @[@"Albums",@"Artists",@"Genres",@"PlayList"]
#define  squadMainColor    [UIColor colorWithRed:(0/255.0f) green:(212/255.0f) blue:(187/255.0f) alpha:1.0f]  //mbHQ
//#define  squadMainColor    [UIColor colorWithRed:(228/255.0f) green:(37/255.0f) blue:(160/255.0f) alpha:1.0f]  //Prev
#define  squadSubColor    [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(88/255.0f) alpha:1.0f]

//ah ln1
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface Utility : NSObject<NSURLSessionDelegate,CustomAlertViewDelegate>

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *audioNameArray;
@property int audioDownloadCount;

+(void)showAlertAfterSevenDayTrail:(UIViewController *)controller;
+(void)showTrailLoginAlert:(UIViewController *)controller ofType:(UIViewController *)ofType;
+(void)showSubscribedAlert:(UIViewController *)controller;
+(void)showProfileEditRestrictionAlert:(UIViewController *)controller;
+(void)showUpgradeDowngradeAlert:(UIViewController *)controller isDowngrade:(BOOL)isDowngrade isUpgrade:(BOOL)isUpgrade;
+(void)showAlertForAppUpdate:(UIViewController *)controller;
+(void)cancelSubscriptionAlert:(UIViewController *)controller isWeb:(BOOL)isWeb;
+(void)inAppPromoAlert:(UIViewController *)controller;
+(void)showTrialWelcomeAlert:(UIViewController *)controller;
+(void)showSetProgramSubscribedAlert:(UIViewController *)controller withData:(NSDictionary *)data;
+(BOOL)isSubscribedUser;
+(BOOL)isSevenDaysCrossedFromInstallation;
+(BOOL)isSquadLiteUser;
+(BOOL)isSquadFreeUser;
+(void) startFlashingbutton:(UIButton *)button;
+(void) stopFlashingbutton:(UIButton *)button;
+(Calorie *)ingredientCalorieCalculation:(float)quantity proteinPer100:(float)proteinPer100 fatPer100:(float)fatPer100 carbPer100:(float)carbPer100 alcoholPer100:(float)alcoholPer100 unit:(NSString *)unit conversionUnit:(NSString *)conversionUnit conversionFactor:(float)conversionFactor;
+(NSString *)totalCalories:(Calorie *)cals;
+(NSDictionary *)replaceDictionaryNullValue:(NSDictionary *)dict;
+(BOOL)isEmptyCheck:(id)data;
+ (BOOL)reachable;
+ (void)msg:(NSString*)str title:(NSString *)title controller:(UIViewController *)controller haveToPop:(BOOL)haveToPop;
+ (void)msgWithPush:(NSString*)str title:(NSString *)title controller:(UIViewController *)controller haveToAnimate:(BOOL)haveToAnimate toController:(UIViewController *)toController;
+ (NSString *)getUrl:(NSString *)api;
+ (NSMutableURLRequest *)getRequest:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action;
+ (void)communityLoginWebserviceCall;
+ (NSMutableURLRequest *)getRequestForNutritionix:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action;

+ (BOOL) validateEmail: (NSString *) email;

+ (BOOL) validatePhoneNumber: (NSString *)phone;

+ (NSMutableURLRequest *)uploadImageWithFileName:(NSString *)fileName withapi:(NSString *)api append:(NSString *)appendString;

+ (CGRect)contentViewWithOrientationForMasterView;

+ (NSString *)hexStringFromColor:(UIColor *)color ;

+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (UILabel*)nodataFound:(NSString *)str originY:(int)originY fontSize:(float)fontSize;//....


+ (BOOL)containsKey: (NSString *)key dictionary:(NSMutableDictionary *)dict;

+ (NSMutableAttributedString *)setSuperscript_StringName:(NSString *)string location:(NSUInteger)location length:(NSUInteger)length mainFont:(UIFont*)mainFont subFont:(UIFont*)subFont;

+(UIImage *)scaleImage:(UIImage *)originalImage width:(int)width height:(int)height;

+ (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension;
+(NSString *)formatTimeFromSeconds:(int)numberOfSeconds;
+ (void)saveImageToDocumentDirectoryFromImageUrl:(NSString *)imageUrlString imageName:(NSString *)imageName ;

+ (UIImage *)getImageFromDocumentDirectoryWithImageName:(NSString *)imageName;

+ (void)removeImage:(NSString *)fileName;

+ (void)writeImageInDocumentsDirectory:(UIImage *)image imageName:(NSString *)imageName;

+(BOOL)deleteImageInDocumentsDirectory:(NSString *)imageName;

+ (UIView *)activityIndicatorView:(UIViewController  *)controller;
+ (UIView *)activityIndicatorView:(UIViewController  *)controller withMsg:(NSString *)msg font:(UIFont *)font color:(UIColor *)color;
-(UIColor*)colorWithHexString:(NSString*)hex;

+(NSMutableURLRequest *)uploadvideoWithData:(NSDictionary *)dataDict withapi:(NSString *)api;

+(NSMutableAttributedString *)getStringWithHeader:(NSString *)headerString headerFont:(UIFont *)headerFont headerColor:(UIColor *)headerColor bodyString:(NSString *)bodyString bodyFont:(UIFont *)bodyFont BodyColor:(UIColor *)BodyColor;
+ (NSString *)daySuffixForDate:(NSDate *)date;   //ah 17

+(NSMutableURLRequest *)getRequestForSpofity:(NSString *)jsonString api:(NSString *)api append:(NSString *)appendString forAction:(NSString *)action accessToken:(NSString *)accessToken url:(NSString *)urlStr;
+(NSString *)getUrlForSpofity:(NSString *)api append:(NSString *)appendString accessToken:(NSString *)accessToken;
+ (NSArray *)shuffleFromArray:(NSMutableArray *)arr;
+ (BOOL) isInt:(NSString *)toCheck;     //ah 2.2
+ (NSAttributedString *)htmlParseWithString:(NSString *)htmlString;
+(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type;
+(NSMutableAttributedString *)convertString:(NSString *)str ToMutableAttributedStringOfFont:(NSString *)font Size:(CGFloat)size WithRangeString:(NSString *)rangeStr RangeFont:(NSString *)rangeFont Size:(CGFloat)rangeSize;      //ah cpn
+(NSString *)calPercentage:(float)totalcal with:(NSNumber *)cal;
+(Calorie *)ingredientCalorieCalculationDetails:(float)quantity proteinPer100:(float)proteinPer100 fatPer100:(float)fatPer100 carbPer100:(float)carbPer100 alcoholPer100:(float)alcoholPer100 unit:(NSString *)unit conversionUnit:(NSString *)conversionUnit conversionFactor:(float)conversionFactor;
+ (void) showToastInsideView:(UIView *)toastSuperView WithMessage:(NSString *)toastMessage;     //ah edit
+ (BOOL)compareImage:(UIImage *)image1 isEqualTo:(UIImage *)image2;

//chayan
+ (void)showHelpAlertWithURL:(NSString*)str controller:(UIViewController *)controller haveToPop:(BOOL)haveToPop;
+(void)updateLeanPlumUserAttributes:(NSDictionary *)dataDict;
- (void) downloadSessionConfiguration;
+ (void) initializeInstructionAt:(UIViewController *)viewController OnViews:(NSArray *) overlayedViews;    //ah ov
+ (UIView *)overlayActivityIndicatorView:(UIViewController  *)controller;  //ah ov
+(NSAttributedString *)getattributedMessage:(NSString *)msg;
+(NSMutableURLRequest *)uploadImageWithFileName:(NSString *)filename withapi:(NSString *)api append:(NSString *)appendString image:(UIImage *)image jsonString:(NSString *)jsonString ;
+(NSMutableURLRequest *)uploadMultipleImage:(NSString *)filename withapi:(NSString *)api append:(NSString *)appendString imageData:(NSDictionary *)imageData jsonString:(NSString *)jsonString;
+(NSString *)convertOneDateFormatStringToAnother:(NSString *)dateString fromDateFormat:(NSString *)fromDateFormat toDateFormat:(NSString *)toDateFormat;
+(NSDate *)convertStringToDate:(NSString *)dateString dateFormat:(NSString *)dateFormat;
+ (NSString *) getDBPath:(NSString *)fileName; // AY 20022018
+(BOOL)isOfflineMode; // AY 21022018
+(void)loginToChatSDK:(NSDictionary *)dict isFb:(BOOL)isFb;
+(void)logoutChatSdk;
+(BOOL)isUserLoggedInToChatSdk;
+(void)updateDataToFirebaseUserMetaUsingAPI;
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;//SetProgram_In
+(NSDictionary*)getPointsImage:(double)point; // gami_badge_popup
+(void)updateUserDetailsToFirebase;
+(void)UpdatePushTokenToFireBaseDBForChat;
+(void)showBadgePopUp:(UIViewController*)controller ofType:(NSString*)type withcolourCode:(NSString*)colourcodeStr ofRange:(NSString*)range;// gami_badge_popup
+(void)cancelscheduleLocalNotificationsForFreeUser;
+(void)cancelscheduleLocalNotificationsForQuote;
+(void)addGamificationPointWithData:(NSDictionary *)data;

+(NSString *)customRoundNumber:(float)value;
+(NSString *)getDateOnly:(NSString *)dateStr;
+(NSArray *)getQuoteListFromJSON;
+(BOOL)needToRedirectToTodayPage;
+(void)removeDefaultObjects;
+(BOOL)checkForFirstDailyWorkout:(UIViewController *)myView;
+(NSAttributedString*)converHtmltotext:(NSString*)htmlText;
+(void)setTheCursorPosition:(UITextView*)textView;
+(void)removeCursor:(UITextView*)textView;
+ (NSString *)timeFormatted:(int)totalSeconds;
+(NSString *)strFromDate:(NSDate*)date;
+(int)weeksOfMonth:(int)month inYear:(int)year;
+(int)secondsFromDate:(NSDate *)date includeSeconds:(BOOL)includeSeconds;
+(NSDate *) nextMondayDate;
+(NSString *) durationStringFromSeconds:(int)totalSeconds includeSeconds:(BOOL)includeSeconds;
+(NSString *) selectedDayStringForReminder:(NSDictionary *)dict;
+(NSString *)createImageFileNameFromTimeStamp;
+(void) startFlashingbuttonForManualSort:(UIButton *)button;
+(void) stopFlashingbuttonForManual:(UIButton *)button;
+(void)logoutAccount_CommunityWebserviceCall;
+(NSArray *)getInAppPurchaseFromJSON;
+(void)communityUpdateUserDataWebserviceCall;
+(void)uploadFile:(NSString *)api image:(UIImage *)image withName: (NSString *) name imageType: (int) imageType itemId:(int)itemId;
+(void)saveImageDetails:(NSString*)localImageName imagetype:(int)imageType Itemid:(int)item_Id existingImageChange:(BOOL)isExistingImageChange selectedImage:(UIImage*)chooseImage;
+(void)localImageSync;
+(void)updateCourseVideoTime:(NSDictionary *)courseDict videoStartTime:(double)videoStartTime;
+(void)updateWebinarVideoTime:(NSDictionary *)webinar videoStartTime:(double)videoStartTime;
+(void)updateWebinarVideoTime_offline:(NSMutableDictionary *)webinar;
+(BOOL)isOnlyProgramMember;
+(void)showNonSubscribedAlert:(UIViewController *)parent sectionName:(NSString *)sectionName;
+ (void) redirectionForUpgrade:(UIViewController *)sender;
+(void)saveWebinarVideoStartTimeIntoTable:(NSDictionary *)webinar videoStartTime:(double)videoStartTime;
+(void)saveShareAlert:(NSDictionary*)dict with:(UIViewController*)controller;
@end
