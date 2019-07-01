package com.example.slatejack.smartfrim1.data;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.slatejack.smartfrim1.R;
import com.example.slatejack.smartfrim1.VerticalAdapter;

import java.util.ArrayList;
import java.util.List;

import static android.content.ContentValues.TAG;

public class VerticalAdapter1 extends RecyclerView.Adapter<VerticalAdapter1.VerticalViewHolder>{
    private Context mContext;//实例化抽象类（包含activity等抽象对象）
    private List<String> mList = new ArrayList<>();//实例化对象
    private VerticalAdapter.OnItemClickListener itemClickListener;

    public interface OnItemClickListener{
        void onItemClick(View view, int position);//该方法回调到activity或fragment中做相应操作
    }
    public void setOnItemClickListener(VerticalAdapter.OnItemClickListener onItemClickListener ){
        this.itemClickListener=onItemClickListener;
    }
    public VerticalAdapter1(Context context) {//传入参数，形参等于实参
        mContext=context;
    }

    public void setVerticalDataList(List<String> list) {
        Log.d(TAG, "setVerticalDataList: " + list.size());//创建日志,方便报错查看
        mList = list;
        notifyDataSetChanged();//动态更新方法调用
    }

    @NonNull
    public VerticalViewHolder onCreateViewHolder1(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate( R.layout.vertical_recycle_item2, parent, false);//实例化视图
        return new VerticalViewHolder(view);//返回视图
    }

    @NonNull
    @Override
    public VerticalAdapter1.VerticalViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return null;
    }

    @Override
    public void onBindViewHolder(@NonNull VerticalViewHolder holder, int position) {
        holder.tv1.setText( mList.get(position) );
    }


    @Override
    public int getItemCount() {
        return mList == null ? 0 : mList.size();//返回list长度

    }

    public class VerticalViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView tv1;
        ImageView im1;
        VerticalAdapter.OnItemClickListener mitemClickListener;//实例化监听器
        public VerticalViewHolder(View itemView) {
            super(itemView);
            tv1=itemView.findViewById( R.id.tv1 );
            im1=itemView.findViewById( R.id.img1 );
            this.mitemClickListener=itemClickListener;
            itemView.setOnClickListener(this);//设置监听器

        }
        @Override
        public void onClick(View v) {
            if (mitemClickListener != null) {
                mitemClickListener.onItemClick(itemView,getPosition());//获取到栏目条的地址，从0开始
            }

        }
    }
}
