package com.example.slatejack.smartfrim1;


import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.preference.PreferenceFragmentCompat;


/**
 * A simple {@link Fragment} subclass.
 */
public class FragmentMy extends PreferenceFragmentCompat {


    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource( R.xml.activity_settings,rootKey );
    }
}
