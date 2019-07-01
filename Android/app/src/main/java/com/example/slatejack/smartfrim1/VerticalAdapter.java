package com.example.slatejack.smartfrim1;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class VerticalAdapter extends RecyclerView.Adapter<VerticalAdapter.VerticalViewHolder> {

    private static final String TAG = VerticalAdapter.class.getSimpleName();//得到类的简写名称，即VerticalAdapter
    private Context mContext;//实例化抽象类（包含activity等抽象对象）
    private List<String> mList = new ArrayList<>();//实例化对象
    private List<String> mList1 = new ArrayList<>();//实例化对象

    private OnItemClickListener itemClickListener;
    public interface OnItemClickListener{
        void onItemClick(View view, int position);//该方法回调到activity或fragment中做相应操作
    }
    public void setOnItemClickListener(OnItemClickListener onItemClickListener ){
        this.itemClickListener=onItemClickListener;
    }
    public VerticalAdapter(Context context) {//传入参数，形参等于实参

        mContext=context;

    }

    public void setVerticalDataList(List<String> list,List<String> list1) {
        Log.d(TAG, "setVerticalDataList: " + list.size());//创建日志,方便报错查看
        mList = list;
        mList1 = list1;
        notifyDataSetChanged();//动态更新方法调用
    }

    @NonNull
    @Override
    public VerticalViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.activity_vertical_recycle_item, parent, false);//实例化视图
        return new VerticalViewHolder(view);//返回视图
    }

    @Override
    public void onBindViewHolder(@NonNull VerticalViewHolder holder, int position) {
        holder.tvNum.setText(position + 1 + "");//设置数字每一次加入一个新的list就加1
        holder.tvContent.setText(mList.get(position));//设置显示内容为list内的文字
        holder.tvIn.setText( mList1.get( position ) );

    }

    @Override
    public int getItemCount() {
        return mList == null ? 0 : mList.size();//返回list长度

    }

    public class VerticalViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView tvNum, tvContent,tvIn;//实例化xml文件中的两个文本控件
        CardView cardView;
        ImageView imageView;
        OnItemClickListener mitemClickListener;//实例化监听器
        public VerticalViewHolder(View itemView) {
            super(itemView);
            tvNum = itemView.findViewById(R.id.tv_num);
            tvContent = itemView.findViewById(R.id.tv_content);
            tvIn=itemView.findViewById( R.id.tv_in );
            cardView=itemView.findViewById( R.id.card );
            imageView=itemView.findViewById( R.id.imageView );
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