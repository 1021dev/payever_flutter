package org.payever.app.taponphone.fragment;


import android.content.Intent;
import android.os.Bundle;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import androidx.fragment.app.DialogFragment;

import org.payever.app.R;
import org.payever.app.taponphone.models.LogType;
import org.payever.app.taponphone.mpos.MposApplication;

import java.util.ArrayList;
import java.util.List;

public class LogTypeSelectionFragment extends DialogFragment {

    /**
     * Key for bundle data to pass transaction logs
     */
    public static final String BUNDLE_KEY = "LOG_TYPE";
    /**
     * List view for log types
     */
    private ListView mLogTypeList;
    /**
     * Button to get the user selected log types
     */
    private Button mButtonLogChoice;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.activity_log_type_selection, null, false);
        mLogTypeList = (ListView) view.findViewById(R.id.list);
        mButtonLogChoice = (Button) view.findViewById(R.id.button_get_log_choice);

        getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(getActivity(),
                android.R.layout
                        .simple_list_item_multiple_choice,
                getResources().getStringArray(
                        R.array.log_type));
        mLogTypeList.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
        mLogTypeList.setAdapter(adapter);
        mButtonLogChoice.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {

                List<LogType> logTypes = new ArrayList<>();
                SparseBooleanArray sparseBooleanArray = mLogTypeList.getCheckedItemPositions();
                for (int i = 0; i < mLogTypeList.getCount(); i++) {
                    if (sparseBooleanArray.get(i)) {
                        String itemAtPosition = mLogTypeList.getItemAtPosition(i).toString();
                        if (itemAtPosition.trim().equalsIgnoreCase(
                                getString(R.string.log_type_debug))) {
                            logTypes.add(LogType.DEBUG);
                        } else if (itemAtPosition.trim().equalsIgnoreCase(
                                getString(R.string.log_type_info))) {
                            logTypes.add(LogType.INFO);
                        } else if (itemAtPosition.trim().equalsIgnoreCase(
                                getString(R.string.log_type_warning))) {
                            logTypes.add(LogType.WARNING);
                        } else if (itemAtPosition.trim().equalsIgnoreCase(
                                getString(R.string.log_type_error))) {
                            logTypes.add(LogType.ERROR);
                        }
                    }
                }

                String transactionLogs =
                        MposApplication.INSTANCE.getDataProvider().getTransactionLogs(logTypes);
                sendResult(transactionLogs);
                getActivity().getSupportFragmentManager().beginTransaction().remove(
                        LogTypeSelectionFragment.this).commit();
            }
        });
    }

    /**
     * Send the transaction logs to {@link TransactionLogsFragment}
     *
     * @param transactionLogs transaction logs
     */
    private void sendResult(String transactionLogs) {
        Intent intent = new Intent();
        intent.putExtra(BUNDLE_KEY, transactionLogs);
        getTargetFragment().onActivityResult(getTargetRequestCode(),
                TransactionLogsFragment.REQUEST_CODE, intent);
    }
}