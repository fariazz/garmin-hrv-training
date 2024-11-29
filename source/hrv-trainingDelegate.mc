import Toybox.WatchUi;

class hrv_trainingDelegate extends WatchUi.BehaviorDelegate {
    private var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onSelect() {
        mView.startBreathingCycle();
        return true;
    }
}
