package cn.linkey.rulelib.S001;

import java.util.HashMap;

import cn.linkey.app.AppUtil;
import cn.linkey.doc.Document;
import cn.linkey.factory.BeanCtx;
import cn.linkey.rule.LinkeyRule;
import cn.linkey.util.Tools;

/**
 * PageList视图拷贝事件
 * 
 * @author Administrator
 * 
 */
public class R_S001_E031 implements LinkeyRule {

    @Override
    public String run(HashMap<String, Object> params) {
        Document gridDoc = (Document) params.get("GridDoc"); // grid配置文档
        Document doc = (Document) params.get("DataDoc"); // 数据主文档
        String eventName = (String) params.get("EventName");// 事件名称
        if (eventName.equals("onGridOpen")) {
            return onGridOpen(gridDoc);
        }
        else if (eventName.equals("onDocDelete")) {
            return onDocDelete(doc, gridDoc);
        }
        else if (eventName.equals("onDocCopy")) {
            return onDocCopy(doc, gridDoc);
        }
        else if (eventName.equals("onBtnClick")) {
            return onBtnClick(doc, gridDoc);
        }
        return "1";
    }

    public String onGridOpen(Document gridDoc) {
        // 如果不返回1则表示退出本视图并输出返回的字符串

        return "1";
    }

    public String onDocDelete(Document doc, Document gridConfigDoc) {
        // 如果不返回1则表示退出本次删除操作，并弹出返回的字符串为提示消息
        return "1";
    }

    public String onDocCopy(Document doc, Document gridConfigDoc) {
        // 如果不返回1则表示退出本次拷贝操作，并弹出返回的字符串为提示消息
        BeanCtx.setCtxData("WF_NoEncode", "1"); // 指定存盘时不进行编码操作

        String appid = doc.g("WF_Appid");
        String sql = "select PageNum from BPM_PageList where WF_Appid='" + appid + "' order by PageNum desc";
        String newNum = AppUtil.getElNewNum(sql);
        if (Tools.isBlank(newNum)) {
            newNum = doc.g("PageNum") + "(Copy)";
        }
        doc.s("PageName", doc.g("PageName") + "(copy)");
        doc.s("PageNum", newNum);
        return "1";
    }

    public String onBtnClick(Document doc, Document gridDoc) {
        // 返回成功的提示信息

        return "";
    }

}