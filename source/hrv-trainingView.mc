import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class hrv_trainingView extends WatchUi.View {
    private var mTimer;
    private var mPhase = 0;  // 0=inhale, 1=hold, 2=exhale, 3=pause
    private var mTimeInPhase = 0;
    private var mCycle = 0;
    private var mIsRunning = false;
    private var mStageText;
    private var mTimerText;
    private var mCycleText;

    function initialize() {
        View.initialize();
        mTimer = new Timer.Timer();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        mStageText = View.findDrawableById("stageText");
        mTimerText = View.findDrawableById("timerText");
        mCycleText = View.findDrawableById("cycleCount");
        mStageText.setText(WatchUi.loadResource(Rez.Strings.Start));
        mTimerText.setText("");
    }

    function startBreathingCycle() {
        if (!mIsRunning) {
            mIsRunning = true;
            mPhase = 0;
            mTimeInPhase = 0;
            mCycle = 1;
            mTimer.start(method(:onTimer), 1000, true);
            updateDisplay();
        }
    }

    function onTimer() {
        mTimeInPhase++;
        
        var phaseComplete = false;
        var currentPhaseLength = 0;
        
        switch(mPhase) {
            case 0: // Inhale
                currentPhaseLength = 4;
                break;
            case 1: // Hold
                currentPhaseLength = 2;
                break;
            case 2: // Exhale
                currentPhaseLength = 5;
                break;
            case 3: // Pause
                currentPhaseLength = 7;
                break;
        }
        
        phaseComplete = mTimeInPhase >= currentPhaseLength;

        if (phaseComplete) {
            mTimeInPhase = 0;
            mPhase = (mPhase + 1) % 4;
            
            if (mPhase == 0) {
                mCycle++;
                if (mCycle > 10) {
                    mTimer.stop();
                    mIsRunning = false;
                    mStageText.setText(WatchUi.loadResource(Rez.Strings.Start));
                    mTimerText.setText("");
                    WatchUi.requestUpdate();
                    return;
                }
            }
        }
        
        updateDisplay();
        WatchUi.requestUpdate();
    }

    function updateDisplay() {
        var text = WatchUi.loadResource(Rez.Strings.Start);
        var totalTime = 0;
        var timeLeft = 0;
        var color;
        
        switch(mPhase) {
            case 0:
                text = WatchUi.loadResource(Rez.Strings.Inhale);
                totalTime = 4;
                color = Graphics.COLOR_BLUE;
                break;
            case 1:
                text = WatchUi.loadResource(Rez.Strings.Hold);
                totalTime = 2;
                color = Graphics.COLOR_YELLOW;
                break;
            case 2:
                text = WatchUi.loadResource(Rez.Strings.Exhale);
                totalTime = 5;
                color = Graphics.COLOR_GREEN;
                break;
            case 3:
                text = WatchUi.loadResource(Rez.Strings.Pause);
                totalTime = 7;
                color = Graphics.COLOR_PURPLE;
                break;
            default:
                text = WatchUi.loadResource(Rez.Strings.Start);
                color = Graphics.COLOR_WHITE;
                break;
        }

        if (mIsRunning) {
            timeLeft = (totalTime - mTimeInPhase) > 0 ? (totalTime - mTimeInPhase) : 0;
            mStageText.setText(text);
            mStageText.setColor(color);
            mTimerText.setText(timeLeft.toString() + "s");
            mTimerText.setColor(color);
            mCycleText.setText("Cycle " + mCycle + " of 10");
        } else {
            mStageText.setText(text);
            mStageText.setColor(Graphics.COLOR_WHITE);
            mTimerText.setText("");
            mCycleText.setText("");
        }
    }

    // Called when this View is brought to the foreground
    function onShow() as Void {
        // ... existing code ...
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen
    function onHide() as Void {
        if (mTimer != null) {
            mTimer.stop();
        }
    }
}