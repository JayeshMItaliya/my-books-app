class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'CANCEL';
  static const String alert = 'BAD NEWS';
  static const String dataCopyToClipBoard = 'URL Copy To ClipBord';
  static const String shareInventoryLink = 'http://mystuff.byebye.io/';

  // Logout
  static const String logout = 'LOG OUT';
  static const String logoutAreYouSure = 'Are you sure you want to log out?';
  static const String logoutFailed = 'Logout failed';

  //
  static const String iHaveRead = 'By continuing, you accept the ';
  static const String termsOfUse = 'TERMS OF USE';
  static const String and = ' and the ';
  static const String privacyPolicy = 'PRIVACY POLICY';

  // Sign In Page
  static const String signIn = 'SIGN IN';
  static const String signInWithEmailPassword = 'CREATE ACCOUNT / SIGN IN';
  static const String signInWithEmailLink = 'Sign in with email link';
  static const String signInWithFacebook = 'SIGN IN WITH FACEBOOK';
  static const String signInWithGoogle = 'SIGN IN WITH GOOGLE';
  static const String signInWithApple = 'SIGN IN WITH APPLE';
  static const String goAnonymous = 'GO ANONYMOUS';
  static const String or = 'or';

  // Email & Password page
  static const String register = 'CREATE YOUR ACCOUNT';
  static const String forgotPassword = 'RESET PASSWORD';
  static const String forgotPasswordQuestion = 'FORGOT YOUR PASSWORD?';
  static const String createAnAccount = 'CREATE NEW ACCOUNT';
  static const String needAnAccount = 'CREATE YOUR ACCOUNT HERE';
  static const String haveAnAccount = 'HAVE AN ACCOUNT? SIGN IN';
  static const String signInFailed = 'SIGN IN FAILED';
  static const String registrationFailed = 'REGISTRATION FAILED';
  static const String passwordResetFailed = 'PASSWORD RESET FAILED';
  static const String sendResetLink = 'SEND RESET LINK';
  static const String backToSignIn = 'BACK TO LOG IN';
  static const String resetLinkSentTitle =
      'The link for password reset has been sent';
  static const String resetLinkSentMessage =
      'Check your inbox (or spam) folder to reset the password';
  static const String emailLabel = 'EMAIL';
  static const String emailHint = ' ENTER YOUR EMAIL';
  static const String password8CharactersLabel = 'PASSWORD (8+ CHARACTERS)';
  static const String passwordLabel = 'PASSWORD';
  static const String invalidEmailErrorText = 'INVALID EMAIL';
  static const String invalidEmailEmpty = 'EMAIL FIELD CAN\'T BE EMPTY';
  static const String invalidPasswordTooShort = 'PASSWORD IS TOO SHORT';
  static const String invalidPasswordEmpty = 'PASSWORD FIELD CAN\'T BE EMPTY';

  // Email link page
  static const String submitEmailAddressLink =
      'Submit your email address to receive an activation link.';
  static const String checkYourEmail = 'Check your email';

  static String activationLinkSent(String email) =>
      'We have sent an activation link to $email';
  static const String errorSendingEmail = 'Error sending email';
  static const String sendActivationLink = 'Send activation link';
  static const String activationLinkError = 'Email activation error';
  static const String submitEmailAgain =
      'Please submit your email address again to receive a new activation link.';
  static const String userAlreadySignedIn =
      'Received an activation link but you are already signed in.';
  static const String isNotSignInWithEmailLinkMessage =
      'Invalid activation link';

  // Home page
  static const String homePage = 'HOME, SWEET HOME';

  // Developer menu
  static const String developerMenu = 'Developer menu';
  static const String authenticationType = 'Authentication type';
  static const String firebase = 'Firebase';
  static const String mock = 'Mock';

  //FileSize Error
  static const String fileSize = 'Fileseize Error';
  static const String fileSizeError = 'Maximum file size is 2Mb.';

  //Genre Error
  static const String genre = 'Duplicated list';
  static const String genreDuplicate =
      'This list already exist. Change the lista name and try again.';

  //Delete Genre warning
  static const String genreDelete = 'Delete List ';
  static const String genreDeleteWarning =
      'Are you sure you want to delete this list?';

  //Delete Book warning
  static const String bookDelete = 'Delete Item';
  static const String bookDeleteWarning =
      'Are you sure you want to delete this item?';

  //Delete Genre error
  static const String genreDeleteError = 'Delete List ';
  static const String genreDeleteErrorDes =
      'You can\'t delete this list because it contains items.';

  //Network Error
  static const String network = 'Network Error';
  static const String networkError = 'Please try again in short time.';

  //Add Book Name
  static const String bookName = 'Name Missing';
  static const String bookNameError = 'Please enter the item\'s name.';

  //Select genre of Book
  static const String bookGenre = 'List Missing';
  static const String bookGenreError = 'Please select an appropriate list.';

  //Enter Book Price
  static const String bookPrice = 'Price Missing';
  static const String bookPriceError = 'Please enter the item\'s price.';

  //Book Volume Error
  static const String bookVolume = 'Quantity Missing';
  static const String bookVolumeError =
      'Please enter the set/batch quantity or select switch back to \'1 UNIT\'.';

  //Book purchase Date
  static const String bookPurchaseDate = 'Item\'S Purchase Date Missing';
  static const String bookPurchaseDateError =
      'Please enter a purchase date or switch back to \'TODAY\'.';

  //Book seller Link
  static const String bookSellerLink = 'Item\'s Seller Link Missing';
  static const String bookSellerLinkError =
      'Please attach a seller link or switch back to \'LATER\'.';

  //Book Description
  static const String bookDescription = 'Item\'s Story Missing';
  static const String bookDescriptionError =
      'Please enter a short story or switch back to \'LATER\'.';

  //Book Photo
  static const String bookPhoto = 'Item\'s Photo Missing';
  static const String bookPhotoError =
      'Please select a photo or switch back to \'LATER\'.';

  //Book match error
  static const String bookMatch = 'Item Duplicate';
  static const String bookMatchError =
      'You already have this item in the list. To avoid confusions save it with another name.';

  //Book regret error
  static const String bookRegret = 'Item\'s Regret Reason Missing';
  static const String bookRegretError =
      'Please enter a reason for this regret.';

  //Add book to regret warning
  static const String bookRegretWarn = 'Regreting An Item';
  static const String bookRegretWarning =
      'Are you sure you want to mark this item as a Regret?';

  //Remove from regret warning
  static const String bookRegretDel = 'Changed your mind?';
  static const String bookRegretDelete =
      'Are you sure you want to remove the item from the regreted list?';

  //Regret error
  static const String favouriteBookRegret = 'Regreting an Item';
  static const String favouriteBookRegretError =
      'This item is one of your favorites. You cannot mark it as a Regret';

  //Favourite Error
  static const String addToFavourite = 'Adding an Item to Favorites List';
  static const String addToFavouriteError =
      'This item is on Regrets list, you cannot add it to Favorites.';

  //Update Views Error
  static const String addView = 'User View';
  static const String addViewError = 'Unable to update this user view.';

  //Library Status warning
  static const String closeLibrary = 'Closing Your Inventory';
  static const String closeLibraryWarning =
      'Closing your inventory shows everyone that you entered all your items in the app. Proceed?';

  static const String openLibrary = 'Opening Your Inventory';
  static const String openLibraryWarning =
      'Opening your inventory shows everyone that you are still in the process of entering items in the app. Proceed?';

  //Update UserInfo warning
  static const String updateInfo = 'Update Your Details';
  static const String updateInfoWarning =
      'You\'ve made changes in your profile. Save and exit?';

  //Username validation warning
  static const String usernameEmpty = 'User Name';
  static const String usernameEmptyWarning = 'Please enter any valid username.';
  static const String dupUserName = 'Duplicate Username';
  static const String dupUserNameWarning =
      'This username already exist. Please try a new one.';
  static const usernameValidation = 'Invalid Username';
  static const usernameValidationWarning =
      'You can choose letters (a-z,A-Z),    and numbers(0-9). At least 3 characters.';

  //Email validation
  static const String validEmail = 'E-mail';
  static const String validEmailWarning = 'Please enter valid e-mail account.';

  //User convenience
  static const String userConvenience = 'Byebye Team';
  static const String userConvenienceWarning =
      'Being in early stages, our app may present some bugs. We\'ll appreciate if instead of a bad review you\'ll send a constructive feedback. Thank you!';

  //Connection Warning
  static const String userConnection = 'DEAD END...';
  static const String userConnectionWarning =
      'This is you :) Check your details in the side navigation drawer.';

  //Marius isolating texts from all over the app

  //sign_in_page
  static const String signInPageWelcome1 =
      'Hi!\n\nCreate an Account \nor Sign In';
  static const String signInPageWelcome2 =
      'Don\'t forget to choose a nice username later.';
  static const String signInPageWelcome3 = 'Quick Sign In';

  //account_preferences

  static const String accountPreferencesAppBar = 'MY BYEBYE APP';

  static const String accountPreferencesTab1 = 'EDIT PROFILE';
  static const String accountPreferencesTab2 = 'APP DETAILS';
  static const String accountPreferencesStoryButton =
      'WHAT\'S YOUR SHORT STORY?';

  static const String accountPreferencesUsername = 'USERNAME';
  static const String accountPreferencesEmail = 'EMAIL';
  static const String accountPreferencesAge = 'AGE';
  static const String accountPreferencesCountry = 'COUNTRY';
  static const String accountPreferencesWorkingIn = 'WORKING IN';
  static const String accountPreferencesGender = 'GENDER';

  static const String accountPreferencesSelectGender = 'Select Your Gender';
  static const String accountPreferencesMale = 'MALE';
  static const String accountPreferencesFemale = 'FEMALE';
  static const String accountPreferencesOther = 'OTHER';
  static const String accountPreferencesSelectCountry = 'SELECT COUNTRY';
  static const String accountPreferencesUpdateRequired =
      ' UPDATE REQUIRED HERE';

  static const String legalVersionTile = 'VERSION';
  static const String legalAndroidVersionText =
      'Byebye App - Version 2 . 0 . 3 (23) .\n\nFollow @ByebyeApp on Twitter for news and cool stuff.\n';
  static const String legalIOSVersionText =
      'Byebye App - Version 2 . 0 . 3 (5) .\n\nFollow @ByebyeApp on Twitter for news and cool stuff.\n';
  static const String legalLicensesTile = 'LICENSES';
  static const String legalLicensesText =
      'Material Design Icons \n© Google under the Apache License 2.0\n\nUnsplash Photos\n© https://unsplash.com/license\n\nAuthentication \n© 2019 Andrea Bizzotto - bizz84@gmail.com\n\nChat\n© 2019 Mohak Gupta - mohak1283@gmail.com\n';
  static const String legalPrivacyTile = 'PRIVACY POLICY';
  static const String legalPrivacyPolicyText =
      'Click HERE for our Privacy Policy\n';

  static const String legalCopyrightTile = 'COPYRIGHT';
  static const String legalCopyrightText =
      '© 2019-2020 Marius Pruna for Byebye Labs Ltd.\n';

  //account story
  static const String accountStoryAppBar = 'MY STORY';
  static const String accountStoryHintText = ' HERE GOES YOUR STORY... ';
  static const String accountStoryButton = 'THAT\'S MY STORY';
  static const String accountStoryStackStoryUpdate = 'STORY UPDATED';

  //bottom navigation bar controller
  static const String bottomNavigationItem1 = 'HOME';
  static const String bottomNavigationItem2 = 'STATS';
  static const String bottomNavigationItem3 = 'MY STUFF';
  static const String bottomNavigationItem4 = 'PEOPLE';
  static const String bottomNavigationItem5 = 'CHAT';

  //drawer
  static const String drawerUserSince = 'USER SINCE';
  static const String drawerMyStory = 'MY STORY';
  static const String drawerInvite = 'INVITE';

  static const String shareText =
      'I use Byebye App to declutter and manage my stuff. Give it a try! https://byebye.io';
  static const String shareSubject = 'You\'ll thank me later!';

  static const String drawerMyAccount = 'MY ACCOUNT';
  static const String drawerViews = 'VIEWS';
  static const String drawerFans = 'FANS';
  static const String drawerNotifications = 'NOTIFICATIONS';
  static const String drawerNotificationsInbox = 'INBOX';
  static const String drawerWhatsNewOnTheBlog = 'What\'s New On The Blog';
  static const String drawerInventory = 'INVENTORY';
  static const String drawerEmptyInventory = 'NOTHING TO SHOW YET...';
  static const String drawerTogether = 'LINKS';
  static const String drawerSupport = 'Buy Us A Coffee!';
  static const String drawerFollow = 'Follow Us On Twitter';
  static const String drawerShare = 'Invite Your Friends';
  static const String drawerBugReport = 'Report A Bug';
  static const String drawerFeedbackIdeas = 'Feedback & Ideas';
  static const String drawerRateApp = 'Rate Our App';
  static const String drawerCommunity = 'Community';
  static const String drawerHelp = 'Get Help';
  static const String drawerThanks = 'Thanks';
  static const String drawerDeleteAccount = 'DELETE ACCOUNT';
  static const String drawerLogOut = 'LOG OUT';

  //getting started
  static const String gettingStartedAppBar = 'GETTING STARTED';
  static const String gettingStartedIntro =
      'Welcome to Byebye! We wish you a happy journey! What we would like you to know:';
  static const String gettingStartedTileTitle1 = 'UPDATE YOUR PROFILE';
  static const String gettingStartedTileText1 =
      'Be relevant by completing your basic details. It is always better to compare apples to apples...';
  static const String gettingStartedTileTitle2 = 'EDIT THE DEMO ENTRIES';
  static const String gettingStartedTileText2 =
      'Get used to Byebye app\'s basic functions with a hands-on approach. More efficient than a walk-through introduction. ';
  static const String gettingStartedTileTitle3 = 'BAD REVIEWS CAN KILL APPS';
  static const String gettingStartedTileText3 =
      'Why not help us bring up a better one? Follow @ByebyeApp on Twitter, use our community forum or our email to report any bug, we\'ll convert it into a feature :)';
  static const String gettingStartedTileTitle4 = 'EXPLORE, SOCIALIZE, LEARN';
  static const String gettingStartedTileText4 =
      'Curiosity drives us all, and the crowd wisdom is unbeatable. Get the best out of this common journey!';
  static const String gettingStartedButton = 'OK, I GOT IT!';

  //home
  static const String homeTileTitle1 = 'GETTING STARTED';
  static const String homeTileSubtitle1 = 'First steps with Byebye';
  static const String homeTileBody1 =
      'We are more than happy to have you here! Let\'s start!';
  static const String homeTileTitle2 = 'QUICK-ADD AN ITEM';
  static const String homeTileSubtitle2 = 'In few simples steps';
  static const String homeTileBody2 =
      'Complete the essentials, do the rest anytime later.';
  static const String homeTileTitle3 = 'GET INSPIRED BY OTHERS';
  static const String homeTileSubtitle3 = 'Curiosity driven';
  static const String homeTileBody3 =
      'Discover other public inventories and learn from them.';
  static const String homeTileTitle4 = 'CHECK YOUR DASHBOARD';
  static const String homeTileSubtitle4 = 'Identify the clutter';
  static const String homeTileBody4 =
      'Have a clear overview of what is in and what must go out.';
  static const String homeTileTitle5 = 'GET HELP';
  static const String homeTileSubtitle5 = 'FAQ\'s and Key Features';
  static const String homeTileBody5 =
      'Find almost everything or ask a specific question online.';
  static const String homeTileTitle6 = 'FOLLOW US ON TWITTER';
  static const String homeTileSubtitle6 = 'Stay connected';
  static const String homeTileBody6 =
      'It\'s where we say things online. Don\'t miss a bit!';
  static const String homeTileTitle7 = 'INVITE YOUR FRIENDS';
  static const String homeTileSubtitle7 = 'Share the experience';
  static const String homeTileBody7 =
      'The more we are, the wiser we get. Spread the vibe!';

  //stats

  //inventory
  static const String inventoryNewCategory = 'NEW LIST';
  static const String inventoryYourNewCategory = 'YOUR NEW LIST';
  static const String inventoryNewCategoryEmpty = 'PLEASE ENTER LIST NAME';
  static const String inventoryNewCategoryHint = ' YOUR NEW LIST';
  static const String inventoryNewCategoryButton = 'ADD A LIST';
  static const String inventoryNewCategorySnackBar = ' LIST WAS CREATED';
  static const String inventoryaddYourFirstList = 'ADD YOUR FIRST \nLIST!';
  static const String inventoryhint1 = 'It can be anything!';
  static const String inventoryhint2 =
      'Clothing, electronics, kitchenware, camping gear, sport, hobby, books, music stuff, and so on...';
  static const String inventoryhint3 =
      'HINT: To get some inspiration, visit the PEOPLE section from the menu below.';

  static const String inventoryListEdit = 'EDIT'; // there is another one bellow
  static const String inventoryListDelete =
      'DELETE'; // there is another one bellow

  static const String inventoryStripeItems = 'ITEMS';
  static const String inventoryItemStripeValue = 'VALUE';
  static const String inventoryItemStripeFavourite = 'FAVORITES';
  static const String inventoryStripeRegrets = 'REGRETS';

  static const String inventorySearchNothingFound = 'NO MATCHES FOUND';
  static const String inventoryAppBarMain = 'LISTS';
  static const String inventoryAppBarSearch =
      ' SEARCH HERE'; // used wherever we have search bar

  static const String inventoryClosedSnack = 'YOUR INVENTORY IS NOW CLOSED';
  static const String inventoryOpenSnack = 'YOUR INVENTORY IS NOW OPEN';
  static const String inventoryshare = 'SHARE \nYOUR LIST';
  static const String inventoryshareDialog =
      '\nA link with your inventory has been created, you can paste it already! \n\nYour inventory will be accessible in any web browser, even if the app is not installed on the device.';
  static const String SwitchInventoryClosed = 'CLOSED\nINVENTORY';

  static const String inventoryCategoryDeleted = 'LIST DELETED';
  static const String inventoryCategoryEdit = 'EDIT YOUR LIST';
  static const String inventoryCategoryEditedSnack = 'LIST EDITED';

  static const String buttonSave = 'SAVE';

  static const String inventoryDropDownAddNewCategory =
      'ADD NEW LIST'; // item_add_new.dart line 121

  static const String inventoryCategoryAll =
      'All'; //hard coded in item_add_new.dart line 62
  static const String inventoryNewItem = 'YOUR NEW ITEM';
  static const String inventoryItemPrice = 'PRICE';
  static const String inventoryNewItemAppBar = 'NEW ITEM DETAILS';
  static const String inventoryNewItemCategoryField = 'LIST';
  static const String inventoryNewItemCategoryDropDown = 'CHOOSE A LIST';

  static const String inventoryNewItemSingle = '1 UNIT';

  static const String inventoryNewItemGroupedHint = 'HOW MANY?';
  static const String inventoryNewItemGroupedSwitcherOn = 'SET / BATCH';
  static const String inventoryNewItemDateSwitcherOff = 'TODAY';
  static const String inventoryNewItemDateSwitcherOnHint = 'PURCHASE DATE';
  static const String inventoryNewItemDateCalendarPicker =
      'CHOOSE PURCHASE DATE';
  static const String inventoryNewItemPhotoSwitcherOff = 'LATER';
  static const String inventoryNewItemPhotoSwitcherOn = 'CHOOSE A PHOTO';
  static const String inventoryNewItemLinkSwitcherOff = 'LATER';
  static const String inventoryNewItemLinkSwitcherOn = 'ATTACH A SELLER LINK';
  static const String inventoryNewItemDescriptionSwitcherOff = 'LATER';
  static const String inventoryNewItemDescriptionSwitcherOn = 'STORY / INFO';
  static const String inventoryNewItemButton = 'FINISH ADDING THIS ITEM';

  static const String inventoryNewItemLinkDialog =
      'ENTER/PASTE THE SHOPPING LINK';

  static const String inventoryNewItemEditedSnack = 'SUCCESFULLY EDITED';
  static const String inventoryNewItemCreatedSnack = 'NEW ITEM ADDED';

  static const String inventoryNewItemNameFieldHint = ' YOUR NEW ITEM';
  static const String inventoryNewItemPriceFieldHint = ' 0'; //was "PRICE"3

  //item details
  static const String itemDetailsStripePrice = 'PRICE';
  static const String itemDetailsStripePurchased = 'PURCHASED';
  static const String itemDetailsStripeUsed = 'USED';
  static const String itemDetailsStripeRegret = 'REGRET';
  static const String itemDetailsStripeLink = 'LINK';

  static const String itemDetailsStripeNoLink =
      'THIS ITEM DOESN\'T HAVE A LINK.';

  static const String itemDetailsStripePhotoTab = 'PHOTO';
  static const String itemDetailsStripeStoryTab = 'STORY';
  static const String itemDetailsStripeRegretTab = 'REGRET';

  static const String itemDetailsStripePhotoOverlay = 'NO PHOTO YET...\n:(';
  static const String itemDetailsStripeNoStoryText = 'NO STORY...';
  static const String itemDetailsStripeNoRegretText =
      'EVERYTHING SEEMS TO BE OK...';

  //book deleted / from above
  static const String itemDetailsStripeLinkedCopiedSnack = 'LINK COPIED';
  static const String itemDetailsStripeRegretUpdatedSnack =
      'REGRET REASON UPDATED';

  //item list
  static const String inventoryItemListEdit = 'EDIT';
  static const String inventoryItemListDelete = 'DELETE';
  static const String inventoryNowAddItems = 'NOW ADD\nAN ITEM!';
  static const String inventoryHintData1 =
      "In 2 simple steps: with a name and price, you're good to go!";
  static const String inventoryHintData2 =
      'For more accurate statistics, we recommend adding a date of purchase, but you can do it anytime later.';
  static const String inventoryHintData3 =
      'Additionally, you can add photos, links and even a short description.';
  static const String noDataFound = 'NOTHING...';

  //books / value / favourites / regrets // take from above
  static const String inventoryItemTabAtoZ = 'A to Z';
  static const String inventoryItemTabFavourites = 'FAVORITES';
  static const String inventoryItemListRegrets = 'REGRETS';

  //search here / from above
  static const String searchBarMessageNoFound = 'SORRY, NO MATCH FOUND';
  static const String removedFromFavourite = 'REMOVED FROM FAVORITES LIST';
  static const String addedToFavourite = 'ADDED TO FAVORITES LIST';
  static const String itemDeleted = 'ITEM DELETED';

  //item regret
  static const String itemRegretAppBar = 'REGRET';
  static const String itemRegretHintText = ' WHAT WAS THE PROBLEM?';
  static const String itemRegretButton = 'COMPLAIN OVER';
  static const String itemRegretConfirmationSnack = 'COMPLAIN UPDATED';

  //item story
  static const String itemStoryAppBar = 'MY ITEM\'S STORY';
  static const String itemStoryHintText = ' HERE GOES THE STORY...';
  static const String itemStoryButton = 'ADD THE ITEM\'S STORY';

  //reuse dialog
  static const String reuseAlertDialogTitle = 'GOOD TO KNOW';
  static const String reuseAlertDialogText =
      'You can monitorize the usage of an item by clicking the icon from the right. This will help the statistics later.\nYou can also revert the counter by long-pressing the same icon.';
  static const String reuseAlertDialogButton = 'OK';

  //people list
  static const String blockUser = 'BLOCK';
  static const String reportUser = 'REPORT';
  static const String blockUserHeader = 'Block This User';
  static const String blockUserWarning =
      'By blocking this user you make its content invisible and unaccessible for you throughout the app.';
  static const String peopleFileBrowseTab = 'BROWSE';
  static const String peopleFileBookmarkedTab = 'FOLLOWING';
  static const String peopleFileHighlightsTab = 'HOTSHOTS';
  static const String peopleFileAppBar = 'PEOPLE';
  static const String peopleHighlightsEmpty = 'THE LIST IS EMPTY';

  //search here - from above
  //no results - from above

  //people file
  // 'ALL' From above /inventoryCategoryAll
  // 'user since' from drawer
  // fans view from drawer - in people_file.dart line 185,
  static const String peopleFileChangeFilterCriteria =
      'CHANGE\nFILTER CRITERIA';
  static const String SwitchActiveUsers = 'ACTIVE\nUSERS';
  static const String peopleFileCategoriesTab = 'LISTS';
  static const String peopleFileItemsTab = 'ITEMS';
  static const String peopleFileAboutTab = 'ABOUT';
  static const String peopleFileConnectionsTab = 'CONNECTIONS';

  static const String peopleFileNoStory = 'NOTHING...';
  static const String peopleFileNoCategories = 'The list is empty';
  static const String peopleFileNoItems = 'The list is empty';
  static const String peopleFileNoItemInCategory = 'The list is empty';
  static const String peopleFileNoConnections = 'NO CONNECTIONS...';

  static const String peopleTileInventoryZero = 'INVENTORY 0';
  static const String peopleTileInventoryText = 'INVENTORY';
  static const String peopleTileFansText = 'FANS';

  static const String peopleBookmarkedText = 'PROFILE FOLLOWED';
  static const String peopleBookmarkedTextSnack =
      'USER ADDED TO YOUR FAVORITES';
  static const String peopleUnBookmarkedText = 'PROFILE UNFOLLOWED';

  //lock on-off explanation
  static const String lockInfoTitle = 'Inventory Status';
  static const String lockInfoText =
      'The users with an open lock icon are still updating items to their inventories.';
  static const String lockInfoButton = 'OK';

  //chat all-users
  static const String chatAvailableTab = 'COMMUNITY';
  static const String chatOpenChatsTab = 'OPEN CHATS';
  static const String chatPhotoContentMarkup = 'Photo';
  static const String chatAppBar = 'CHAT';
  static const String chatDeleted = 'CHAT DELETED';

  //chat screen
  static const String chatScreenCopy = 'COPIED';
  static const String chatScreenNotAvailable = 'Not available';
  static const String chatScreenCouldNotLaunch = 'Could not launch';
  static const String chatScreenTypeMessage = 'Type your message...';

  //onboarding
  static const String OnBoarding1Phrase1 =
      'Your stuff in one place, \nthe list of anything';
  static const String OnBoarding1Phrase2 =
      'Organize. Control. Identify the excess and declutter.';
  static const String OnBoarding2Phrase1 = 'Get inspired by others\nlike you';
  static const String OnBoarding2Phrase2 =
      'Discover people\'s inventories\nand learn from them';
  static const String OnBoarding3Phrase1 = 'Join our fast growing\ncommunity';
  static const String OnBoarding3Phrase2 =
      'Inspiring people, minimalism,\nand intentionality';
  static const String OnboardingBack = 'BACK';
  static const String OnboardingNext = 'NEXT';
  static const String OnboardingGetStarted = 'GET STARTED';

// Hi Parth, please put here any other texts and I will arrange them later. Many thanks!
  static const String monthDiff =
      'Ending date should be after starting date, chronologically. Try again.';
  static const String selectCorrectMonth = 'Please select Correct month';

  //Stats
  static const String statsAppbarTitle = 'STATS';
  static const String statsItemTabSpending = 'SPENDING';
  static const String statsItemTabBreakdown = 'BREAKDOWN';
  static const String statsItemTabMonthly = 'MONTHLY';
  static const String statsBooksValue = 'VALUE';
  static const String statsBooksVolume = 'ITEMS';
  static const String statsBooksAvgPrice = 'AVG. PRICE';
  static const String statsBooksRegretValue = 'REGRET';
  static const String statsNoBarChartAvailable = 'NO CHART AVAILABLE HERE :(';
  static const String statsYAxisValueSpent = 'SPENT';
  static const String statsYAxisValueBooks = 'ITEMS';
  static const String statsShowValuesOfChart = 'DETAILS';
  static const String statsSelectCustomMonths = 'Select Your Custom Range';
  static const String statsSelectStartMonth = 'Select starting month';
  static const String statsStartMonth = 'Choose starting month';
  static const String statsSelectEndMonth = 'Select ending month';
  static const String statsEndMonth = 'Choose ending month';
  static const String statsNoPieChartAvailable = 'NO CHART AVAILABLE HERE :(';

  static const String statsCurrentYear = 'Current Year';
  static const String statsAllTime = 'All Time';
  static const String statsLastYear = 'Last Year';
  static const String statsCurrentMonth = 'Current Month';
  static const String statsLastMonth = 'Last Month';
  static const String statsCustom = 'Custom';
  static const String statsWholeInventory = 'Whole Inventory';

  // Filter people
  static const String peopleFilteringAppBar = 'PEOPLE FILTER';
  static const String peopleApplyFilter = 'APPLY FILTER';
  static const String peopleFilterRestoreToDefault = 'RESET ALL FILTERS';

  // Filter By Gender
  static const String peopleFilterByGender = 'GENDER';
  static const String peopleFilterByAllGender = 'ALL GENDERS';
  static const String peopleFilterByMale = 'MALE';
  static const String peopleFilterByFemale = 'FEMALE';
  static const String peopleFilterByOther = 'OTHER';

  // Filter By Age
  static const String peopleFilterByAge = 'AGE';
  static const String peopleFilterByAllAge = 'ALL AGES';
  static const String peopleFilterByUnderTwenty = 'Under 20';
  static const String peopleFilterByTwentyToThirty = '21-30';
  static const String peopleFilterByThirtyToFourty = '31-40';
  static const String peopleFilterByFourtyPlus = '40+';

  // Filter By Inventory
  static const String peopleFilterByInventory = 'INVENTORY';
  static const String peopleFilterByAllInventory = 'ALL';
  static const String peopleFilterByMoreThanTwentyFive = 'More than 25 items';
  static const String peopleFilterByMoreThanFifty = 'More than 50 items';
  static const String peopleFilterByMoreThanHundred = 'More than 100 items';
  static const String peopleFilterByMoreThanTwoHundred = 'More than 200 items';

  // Filter By Activity
  static const String peopleFilterByActivity = 'ACTIVITY';
  static const String peopleFilterByAllActivity = 'ACTIVE ANYTIME';
  static const String peopleFilterByActiveInPastDaysAgo = 'Active In the past';
  static const String peopleFilterByCurrentDay = 'Active Today';
  static const String peopleFilterByActiveNow = 'Active Now';

  // DELETE CHAT STRING
  static const String deleteChatContent =
      'Do you want to delete this conversation?';
  static const String deleteChatTitle = 'Delete Chat';

  //Delete Account Warning
  static const String deleteAccountPermanent = 'Delete Account';
  static const String deleteAccountContent =
      'You are about to delete your account. Forever.';
  static const String deleteAccountSuccessfully = 'Delete Successfully';
  static const String deleteAccountSuccessContent =
      'Account Successfully Revoked From Application';
  static const String noRecordFound =
      'NOTHING TO SHOW, PLEASE REFINE YOUR SEARCH...';

  //Update New Version Dialog
  static const String updateAvailTitle = 'New Features Available';
  static const String updateAvailMessage =
      'Hey, looks like you have an older version of the app!';
  static const String btnUpdateNow = 'UPDATE NOW';
  static const String btnCancel = 'LATER';

  //Inbox Notification Messages
  static const String notificationMessageAppBar = 'MESSAGE';
  static const String notificationNotAvailable = 'NO NOTIFICATIONS YET...';

  //Book-Love-Helper.dart Activity Strings - NOT IMPLEMENTED YET - @MARIUS
/*  static const String activityActive = 'ACTIVE';
  static const String activityDay = 'DAY';
  static const String activityDays = 'DAYS';
  static const String activityMinute = 'MIN';
  static const String activityMinutes = 'MIN';
  static const String activityHour = 'HR';
  static const String activityHours = 'HRS';
  static const String activityAgo = 'AGO';
  static const String activityActiveOneDayAgo = 'ACTIVE 1 DAY AGO';
  static const String activityActiveToday = 'ACTIVE TODAY';
  static const String activityActiveNow = 'ACTIVE NOW';
  static const String activityAppNotUpdatedYet = 'APP NOT UPDATED YET';*/








}


