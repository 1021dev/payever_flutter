package org.payever.app.taponphone.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import com.google.android.material.snackbar.Snackbar;

import org.payever.app.R;
import org.payever.app.taponphone.utils.DataManager;

import java.util.List;


public class TransactionOptionsFragment extends BaseFragment implements
        AdapterView.OnItemSelectedListener,
        View.OnClickListener {

    private final String TAG = "TxnOptionsFragment";

    /**
     * Transaction Type spinner
     */
    private Spinner mTransactionTypeSpinner;

    /**
     * Available Profile Spinner
     */
    private Spinner mProfileSpinner;
    /**
     * Root view of TransactionOptionsFragment
     */
    private View mRootView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        mRootView = inflater.inflate(R.layout.fragment_transaction_options, container, false);

        getActivity().setTitle(getString(R.string.transaction_options));

        DataManager dataStorage = getDataManager();

        Button buttonSave = (Button) mRootView.findViewById(R.id.button_save);
        buttonSave.setOnClickListener(this);

        List<String> transactionTypeList = getDataProvider().getTransactionTypeList();
        mTransactionTypeSpinner = (Spinner) mRootView.findViewById(R.id.transaction_type_spinner);
        mTransactionTypeSpinner.setOnItemSelectedListener(this);
        ArrayAdapter txnTypeAdaptor = new ArrayAdapter(mRootView.getContext(),
                android.R.layout.simple_spinner_item, transactionTypeList);
        txnTypeAdaptor.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mTransactionTypeSpinner.setAdapter(txnTypeAdaptor);

        mTransactionTypeSpinner.setSelection(txnTypeAdaptor.getPosition(
                dataStorage.getStringData(DataManager.KEY_TRANSACTION_TYPE)));

        //=============================

        List<String> profileList = getDataProvider().getAvailableProfiles();
        mProfileSpinner = (Spinner) mRootView.findViewById(R.id.profile_spinner);
        mProfileSpinner.setOnItemSelectedListener(this);
        ArrayAdapter profileListAdaptor = new ArrayAdapter(mRootView.getContext(),
                android.R.layout.simple_spinner_item, profileList);
        profileListAdaptor.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mProfileSpinner.setAdapter(profileListAdaptor);
        mProfileSpinner.setSelection(profileListAdaptor.getPosition(
                dataStorage.getStringData(DataManager.KEY_ACTIVE_READER_PROFILE)));

        return mRootView;
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button_save:
                onSaveButton();
                break;
            default:
                Log.e(TAG, "onClick: An uknown button was clicked ");
        }
    }


    private void onSaveButton() {
        DataManager dataStorage = getDataManager();

        dataStorage.saveStringData(DataManager.KEY_TRANSACTION_TYPE,
                (String) mTransactionTypeSpinner.getSelectedItem());

        dataStorage.saveStringData(DataManager.KEY_ACTIVE_READER_PROFILE,
                (String) mProfileSpinner.getSelectedItem());

        Snackbar.make(mRootView, getString(R.string.data_saved),
                Snackbar.LENGTH_LONG).show();
    }
}
