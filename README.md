# Technology-Driven-Active-Learning-in-Human-Anatomy-Laboratory-Ver-1.0

In order to compile, work and run the project you need to do the following:

### Install CocoaPods

To install CocoaPods follow the instructions in the official site: https://cocoapods.org/

Basically run: ```sudo gem install cocoapods``` in a Terminal and if everything went smooth, then you're good to go.

###Clone or download the project

 - Download or clone the ```develop``` branch.
 - Open a Terminal and head to the root folder of the project (the one containing the ```Podfile``` file)
 - Run ```pod install --verbose```. You should see the installation output in the terminal.
 - After the installation of the pods completes. Open Finder and go the the project folder, you should see ```.xcworkspace``` file. This is the one you have to open, not the ```.xcodeproj```.
 - After you open the workspace, you should see two projects in Xcode left side menu, ```Anatomy Lab``` and ```Pods```.
 - You can now work on the project.

###Collaborative work

A proven and safe way to work collaboratively consists in separating your work from the ```develop``` branch, never touch the ```master``` branch and ask your teammates to review your pull requests.

####A typical workflow is as follows:

Let's say you want to develop a new ```login``` feature, then:

 - You clone or download the ```develop``` branch.
 - In ```Xcode```, you create a new branch. This is done through the menu option ```Source Control > ``` Your current branch (should be develop) ``` > New branch```
 - You can name the new branch ```login```
 - Then commit and push your work only to this branch.

Once you consider your feature is ready for testing or integration, submit a pull request in Github. This PR should be submitted to merged into the ```develop``` branch. You have to ask a teammate to review your code before merging. If the teammate find mistakes or have suggestions, you should improve your code. Once everybody is happy with it, then it can be merged into ```develop```.

For further reference: http://nvie.com/posts/a-successful-git-branching-model/