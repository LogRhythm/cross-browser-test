Cross Browser / General Bug Fixing : Test
==================

This application was built to test your bug fixing abilities. Its fairly simple,
but reasonably reflects the type of problems you are likely to encounter when
working on web applications for LogRhythm.

This test uses the following key technologies:

- [Git](http://git-scm.com/)
- [Node.js](http://nodejs.org/)
- [Angular.js](http://angularjs.org/)
- [Coffee-Script](http://coffeescript.org/)
- [Stylus](http://learnboost.github.io/stylus/) (a CSS transpiler similar to SCSS)
- [E J S](http://embeddedjs.com/)
- [Express](http://expressjs.com/)
- [Grunt](http://gruntjs.com/)

For Testing :

- [Karma](http://karma-runner.github.io/0.12/index.html)
- [Mocha](http://visionmedia.github.io/mocha/)
- [Chai](http://chaijs.com/)
- [PhantomJS](http://phantomjs.org/)

## Getting Going

First you will need to clone this git repository to your local computer. After you
have done that. Please run:

```
  npm install
```
then
```
  npm install -g bower
  bower install
```

these commands will pull in all project dependencies. This project also uses
the fabulous grunt task runner. If you do not already have grunt installed, you
will need to run:

```
  npm install -g grunt-cli
```

## Grunt

Now that you have your tools in place, the project has been packaged with the 
following grunt tasks.

### `grunt build`

This command will clean and build all the Coffee-Script and Stylus files into the
rendered JavaScript and CSS for the browser. It will also 'watch' those files and
recompile them on the fly. While working on this project, you will need to leave
this task running.

### `grunt karma`

This command will run the unit tests and returns and output to the terminal. 
It will also 'watch' your Coffee-Script files and re-run the tests when those 
files change. While working on this project, its recommend that you leave this
task running. If you wish to run the tests in a specific browser simply navigate to
`localhost:9876`, the browser should instantly connect and run the tests.

### `grunt start`

This command will start the node server process. Because this process runs on 
port 80 you will need to run this command with `sudo` or `as administrator`.
Once this tasks gets going you will be able to see the application running on
`localhost`.

## Acceptance Criteria

We are targeting the following browsers for this project:

- Internet Explorer 9 (Windows)
- Internet Explorer 10 (Windows)
- Internet Explorer 11 (Windows)
- Google Chrome (Mac and Windows)
- Firefox (Mac and Windows)
- Safari (Mac)

The application should function identically and all unit tests should be 
passing in all above browsers. The application should behave as expected and work
with the intent expressed by the visual ui and the code as much as possible. 

## Delivering your test application. 

We ask that you do **NOT** post a public repository with your finished test. Instead
please send us a .zip/.tar.gz/.tar/ect archive **INCLUDEING** your `.git` folder. 
Please commit to git early and often just as you would on a real project.
