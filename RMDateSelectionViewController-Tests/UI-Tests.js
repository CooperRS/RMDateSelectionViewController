var testName = "UI-Tests";
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

UIALogger.logStart(testName);
app.logElementTree();

UIALogger.logMessage("Opening date selection...");
target.tap({x:160, y:121});
target.delay(1.3);

UIALogger.logMessage("Tapping now button...");
target.tap({x:170, y:256});
target.delay(1);

UIALogger.logMessage("Tapping select button...");
target.tap({x:235, y:536});
target.delay(0.5);

UIALogger.logMessage("Opening date selection...");
target.tap({x:160, y:121});
target.delay(1.3);

UIALogger.logMessage("Tapping cancel button...");
target.tap({x:84, y:536});
target.delay(0.5);

UIALogger.logMessage("Opening modal view controller...");
target.tap({x:160, y:185});
target.delay(1);

UIALogger.logMessage("Opening date selection...");
target.tap({x:160, y:121});
target.delay(1.3);

UIALogger.logMessage("Tapping cancel button...");
target.tap({x:84, y:536});
target.delay(0.5);

target.logElementTree();