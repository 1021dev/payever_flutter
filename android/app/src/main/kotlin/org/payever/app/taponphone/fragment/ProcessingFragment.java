package org.payever.app.taponphone.fragment;

import android.media.AudioManager;
import android.media.ToneGenerator;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.fragment.app.FragmentTransaction;

import org.payever.app.R;
import org.payever.app.taponphone.api.BaseApi;
import org.payever.app.taponphone.listener.TransactionListener;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.widgets.ProgressWheel;


public class ProcessingFragment extends BaseFragment implements View.OnClickListener,
        TransactionListener {


    private final String TAG = "ProcessingFragment";

    /**
     * Total timeout seconds
     */
    private static final int TIMEOUT_MILLISECONDS = 30 * 1000;
    /**
     * Instance of {@link CountDownTimer}
     */
    private CountDownTimer mTimeoutTimer;

    /**
     * Instance of {@link ProgressWheel}
     */
    private ProgressWheel mProgressWheel;
    /**
     * Remaining seconds
     */
    private int mSecondsRemaining = 50 + 1;
    /**
     * Processing wheel red color
     */
    private int mWheelColorRed;
    /**
     * Processing wheel orange color
     */
    private int mWheelColorOrange;
    /**
     * Processing wheel blue color
     */
    private int mWheelColorBlue;
    private View rootView;

    private TransactionListener mTransactionListener;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        rootView = inflater.inflate(R.layout.fragment_processing, container, false);

        getActivity().setTitle(getString(R.string.title_accept_payment));


        TextView textProcessing = (TextView) rootView.findViewById(R.id.text_processing);
        textProcessing.setText("Please tap a card");

        mProgressWheel = (ProgressWheel) rootView.findViewById(R.id.progress_wheel);

        Button buttonCancel = (Button) rootView.findViewById(R.id.button_cancel);
        buttonCancel.setOnClickListener(this);

        initProgressWheel();

        MposApplication.INSTANCE.getTransactionOutcomeObserver().resetObserver(this);

        mTransactionListener = this;
        BaseApi.performTransaction(mTransactionListener);

        return rootView;
    }

    /**
     * Initialize the processing wheel
     */
    private void initProgressWheel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            mWheelColorRed = getResources().getColor(R.color.progress_wheel_bar_red, null);
            mWheelColorOrange = getResources().getColor(R.color.progress_wheel_bar_orange, null);
            mWheelColorBlue = getResources().getColor(R.color.progress_wheel_bar_green, null);
        } else {
            mWheelColorRed = getResources().getColor(R.color.progress_wheel_bar_red);
            mWheelColorOrange = getResources().getColor(R.color.progress_wheel_bar_orange);
            mWheelColorBlue = getResources().getColor(R.color.progress_wheel_bar_green);
        }

        mProgressWheel.setOnClickListener(onWheelClickListener);

        mTimeoutTimer = new CountDownTimer(TIMEOUT_MILLISECONDS, 100) {

            public void onTick(long millisUntilFinished) {
                int newSecondsRemaining = (int) Math.ceil(millisUntilFinished / 1000f);
                if (newSecondsRemaining != mSecondsRemaining) {
                    // Keep track of the new seconds remaining
                    mSecondsRemaining = newSecondsRemaining;

                    // Set the color of the wheel depending on the number of seconds remaining
                    if (mSecondsRemaining <= TIMEOUT_MILLISECONDS / 3000) {
                        mProgressWheel.setRimColor(mWheelColorRed);
                    } else if (mSecondsRemaining <= TIMEOUT_MILLISECONDS * 2 / 3000) {
                        mProgressWheel.setRimColor(mWheelColorOrange);
                    } else if (mSecondsRemaining >= TIMEOUT_MILLISECONDS * 2 / 3000) {
                        mProgressWheel.setRimColor(mWheelColorBlue);
                    }

                    int progress = (int) (((TIMEOUT_MILLISECONDS - millisUntilFinished) / (
                            TIMEOUT_MILLISECONDS * 1.0f)) * 360);
                    mProgressWheel.setProgress(progress);
                }
            }

            public void onFinish() {
                mProgressWheel.setProgress(360);
                // Abort transaction if transaction is not completed in 50sec
                BaseApi.abortTransaction(mTransactionListener);
            }
        }.start();
    }

    private final View.OnClickListener onWheelClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            mTimeoutTimer.cancel();
            mTimeoutTimer.start();
        }
    };


    private void stopTimer() {
        if (mTimeoutTimer != null) {
            mTimeoutTimer.cancel();
        }
    }

    /**
     * Replace the current fragment to {@link HomeFragment}
     */
    private void launchHomeFragment(final String status) {
        stopTimer();
        if (getActivity() != null) {
            FragmentTransaction fragmentTransaction =
                    getActivity().getSupportFragmentManager().beginTransaction();
            fragmentTransaction.replace(R.id.content_frame, new HomeFragment());
            fragmentTransaction.commit();
        }
        // Display transaction status
        if (getActivity() != null) {
            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (!status.isEmpty()) {
                        Toast.makeText(rootView.getContext(), "Transaction: " + status,
                                Toast.LENGTH_LONG).show();
                    } else {
                        Toast.makeText(rootView.getContext(), "Transaction: Timed out",
                                Toast.LENGTH_LONG).show();
                    }
                }
            });
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button_cancel:
                BaseApi.abortTransaction(mTransactionListener);
                break;
            default:
                Log.e(TAG, "onClick: An unknown Button was clicked");
        }
    }

    @Override
    public void onTransactionSuccessful() {
        launchHomeFragment("Successful");
    }

    @Override
    public void onOnlineReferral() {
        launchHomeFragment("Successful -  Online Referral");
    }

    @Override
    public void onTransactionDeclined() {
        launchHomeFragment("Declined");
    }

    @Override
    public void onApplicationEnded() {

        ToneGenerator toneGen1 = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
        toneGen1.startTone(ToneGenerator.TONE_CDMA_PIP, 150);
        launchHomeFragment("Application Ended");
    }

    @Override
    public void onTransactionCancelled() {

        ToneGenerator toneGen1 = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
        toneGen1.startTone(ToneGenerator.TONE_CDMA_PIP, 150);
        launchHomeFragment("Cancelled");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy: Processed");
    }
}
