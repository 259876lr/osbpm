package cn.linkey.rulelib.S001;

import java.io.File;
import java.util.HashMap;

import cn.linkey.app.AppUtil;
import cn.linkey.doc.Document;
import cn.linkey.rule.LinkeyRule;

/**
 * @RuleName:打包新版本
 * @author admin
 * @version: 8.0
 * @Created: 2014-04-08 09:52
 */
public class R_S001_E037 implements LinkeyRule {

    @Override
    public String run(HashMap<String, Object> params) throws Exception {
        //获取事件运行参数
        Document formDoc = (Document) params.get("FormDoc"); //表单配置文档
        Document doc = (Document) params.get("DataDoc"); //数据主文档
        String eventName = (String) params.get("EventName");//事件名称
        if (eventName.equals("onFormOpen")) {
            String readOnly = (String) params.get("ReadOnly"); //1表示只读，0表示编辑
            return onFormOpen(doc, formDoc, readOnly);
        }
        else if (eventName.equals("onFormSave")) {
            return onFormSave(doc, formDoc);
        }
        return "1";
    }

    public String onFormOpen(Document doc, Document formDoc, String readOnly) {
        //当表单打开时
        if (readOnly.equals("1")) {
            return "1";
        } //如果是阅读状态则可不执行
        if (doc.isNewDoc()) {
            //可以对表单字段进行初始化如:doc.s("fdname",fdvalue),可以获取字段值 doc.g("fdname")
        }
        String appid = doc.g("WF_Appid");
        String filename = appid + "_V" + doc.g("VersionNo") + ".xml";
        String filePath = AppUtil.getPackagePath() + filename;
        File file = new File(filePath);
        if (file.exists()) {
            doc.s("filepath", "<a href='r?wf_num=R_S001_B020&filename=" + filename + "' >点击下载:" + filename + "</a>");
        }
        return "1"; //成功必须返回1，否则表示退出并显示返回的字符串
    }

    public String onFormSave(Document doc, Document formDoc) throws Exception {
        //当表单存盘前
        //获得所有设计元素所在的表名
        String appid = doc.g("WF_Appid");
        String fileName = appid + "_V" + doc.g("VersionNo") + ".xml";
        AppUtil.packageApp(appid, fileName);

        doc.s("FileName", fileName);
        return "1"; //成功必须返回1，否则表示退出存盘
    }

}