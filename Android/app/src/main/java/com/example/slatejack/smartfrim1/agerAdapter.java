package com.example.slatejack.smartfrim1;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentStatePagerAdapter;

public class agerAdapter extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    public agerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                TapFragment1 tab1 = new TapFragment1();
                return tab1;
            case 1:
                FragementSet1 tab2=new FragementSet1();
                return tab2;
            default:
                return new TapFragment1();
        }
    }

    @Override
    public int getCount() {
        return mNumOfTabs;
    }
}
