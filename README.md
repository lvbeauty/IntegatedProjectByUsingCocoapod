May 27 Wednsday
# Project: Touch Novel

Touch Novel is a demo project for reading various Novels being dynamically fetched from the Google Books API.

The idea was to leverage various third-party libraries that I wanted to use.

App Demo: https://drive.google.com/file/d/17pZYLQfH7-GlcXzSQYJWHS3ST7fzuMfT/view?usp=sharing



Third-Party Libraries being used:

1. Alamofire: 
Alamofire provides a variety of convenience methods for making HTTP requests.  
-> I use it to get data from API

2. Nuke:
Nuke provides a simple and efficient way to download and display images in your app. Behind its clear and concise API is an advanced architecture which enables its unique features and offers virtually unlimited possibilities for customization.  
-> I use it to load Image from url.

3. ViewAnimator
ViewAnimator is a library for building complex iOS UIView animations in an easy way. It provides one line animations for any view included the ones which contain other views like UITableView and UICollectionView with its cells or UIStackView with its arrangedSubviews.
-> I use it to animate the collection cell in the tabBarController First page

4. MBProgressHUD
MBProgressHUD is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread.
-> I use it to be an activity indicator when the webkit view is loading web page (using in WebViewController)

Code Updates: 
1. select and delete collection items
2. click the cell at the first page of the tab bar controller, it will push to the webkit view controller.
3. using MBProgressHUD library
4. using ViewAnimator library
// new updates
5. fix navigation bar issue for the first view controller

Feature work:
1. wanna optimaze the NetworkManager
2. wanna use pull-to-refresh which is -> when you pull down the view, it will auto refresh
3. wanna fix some bugs about login page
4. wanna improve the appearance of the profile page. 
5. wanna make the feature page have more function. 
e.g.:  if I select the collection cell item which in the table view cell, and push the heart button in the nav bar, then I can add the book into the first page.

