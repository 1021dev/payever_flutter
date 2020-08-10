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

import androidx.annotation.Nullable;

import com.google.android.material.snackbar.Snackbar;

import org.payever.app.R;
import org.payever.app.taponphone.api.SampleDataProviderImpl;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.utils.DataManager;

import java.util.List;

public class TerminalOptionsFragment extends BaseFragment implements
        AdapterView.OnItemSelectedListener,
        View.OnClickListener {

    private final String TAG = "TerminalOptionsFragment";

    /**
     * Spinner to display country
     */
    private Spinner mCountrySpinner;
    /**
     * Spinner to display currency
     */
    private Spinner mCurrencySpinner;
    /**
     * Root view of TerminalOptionsFragment
     */
    private View mRootView;
    public static final String COUNTRY_CODE = "9F1A";


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        mRootView = inflater.inflate(R.layout.fragment_terminal_options, container, false);
        getActivity().setTitle(getString(R.string.terminal_options));

        mCountrySpinner = (Spinner) mRootView.findViewById(R.id.country_spinner);
        mCurrencySpinner = (Spinner) mRootView.findViewById(R.id.currency_spinner);

        mCountrySpinner.setOnItemSelectedListener(this);
        mCurrencySpinner.setOnItemSelectedListener(this);

        SampleDataProviderImpl uiDataInterface = getDataProvider();

        List<String> countryList = uiDataInterface.getCountryList();

        ArrayAdapter countryAdapter = new ArrayAdapter(mRootView.getContext(),
                android.R.layout.simple_spinner_item,
                countryList);
        countryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mCountrySpinner.setAdapter(countryAdapter);

        List<String> currencyList = uiDataInterface.getCurrencyList();

        ArrayAdapter currencyAdapter = new ArrayAdapter(mRootView.getContext(),
                android.R.layout.simple_spinner_item,
                currencyList);
        currencyAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mCurrencySpinner.setAdapter(currencyAdapter);

        Button buttonSave = (Button) mRootView.findViewById(R.id.button_save);
        buttonSave.setOnClickListener(this);

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
                Log.e(TAG, "onClick: An unknown button was clicked");
        }
    }

    private void onSaveButton() {
        String selectedCountry = (String) mCountrySpinner.getSelectedItem();

        DataManager dataStorage = getDataManager();
        dataStorage.saveStringData(DataManager.KEY_COUNTRY, selectedCountry);
        String value = DataManager.CountryCode.valueOf(selectedCountry).getCountryCode();
        // update terminal configuration with selected country code
        MposApplication.INSTANCE.updateTerminalData(COUNTRY_CODE, value);

        String selectedCurrency = (String) mCurrencySpinner.getSelectedItem();
        dataStorage.saveStringData(DataManager.KEY_CURRENCY, selectedCurrency);

        Snackbar.make(mRootView, getString(R.string.data_saved),
                Snackbar.LENGTH_LONG).show();
    }
}
