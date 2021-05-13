package com.wjj.crm.workbench.web.controller;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.PrintJson;
import com.wjj.crm.utils.ServiceFactory;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.MaterialDao;
import com.wjj.crm.workbench.domain.Material;
import com.wjj.crm.workbench.service.MaterialService;
import com.wjj.crm.workbench.service.impl.MaterialServiceImpl;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.ibatis.session.SqlSessionFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MaterialController extends HttpServlet {
    //1.设置文件存贮目录
    private static final String UPLOAD_DIRECTORY = "material";
    // 上传配置
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到活动控制器");
        String path = request.getServletPath();
        if ("/workbench/material/saveMaterial.do".equals(path)) {
            try {
                saveMaterial(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("/workbench/material/pageList.do".equals(path)) {
            pageList(request, response);
        }else if ("/workbench/material/delete.do".equals(path)) {
            delete(request, response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除素材的操作");
        String ids[]=request.getParameterValues("id");
        MaterialService materialService= (MaterialService) ServiceFactory.getService(new MaterialServiceImpl());
        boolean flag=materialService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询客户列表");
        String title=request.getParameter("title");
        String pageNostr=request.getParameter("pageNo");
        String pageSizestr=request.getParameter("pageSize");
        //mysql里面的limit(skipCount,pageSize)分页查询,skipCount是略过的记录数，pageSize是每页展现的记录数
        int pageNo=Integer.parseInt(pageNostr);
        int pageSize=Integer.parseInt(pageSizestr);
        //计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("title",title);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        MaterialService materialService= (MaterialService) ServiceFactory.getService(new MaterialServiceImpl());

        PaginationVo<Material> vo= materialService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void saveMaterial(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("进入上传素材的操作");
        request.setCharacterEncoding("utf-8");
        // 检测是否为多媒体上传
        if (!ServletFileUpload.isMultipartContent(request)) {
            // 如果不是则停止
            PrintWriter writer = response.getWriter();
            writer.println("Error: 表单必须包含 enctype=multipart/form-data");
            writer.flush();
            return;
        }
        //配置上传参数
        //1.创建工厂
        // 配置上传参数
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置内存临界值 - 超过后将产生临时文件并存储于临时目录中
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // 设置临时存储目录
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        ServletFileUpload upload = new ServletFileUpload(factory);
        // 设置最大文件上传值
        upload.setFileSizeMax(MAX_FILE_SIZE);
        // 设置最大请求值 (包含文件和表单数据)
        upload.setSizeMax(MAX_REQUEST_SIZE);
        // 中文处理
        upload.setHeaderEncoding("UTF-8");
        // 构造临时路径来存储上传的文件
        // 这个路径相对当前应用的目录
        String uploadPath = request.getSession().getServletContext().getRealPath("./") + File.separator + UPLOAD_DIRECTORY;
        System.out.println(uploadPath);
        // 如果目录不存在则创建
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        //map用来存放非文件的文本参数
        Map<String,String> map=new HashMap<String,String>();
        //文件路径，url
        String filepath="";
        String fileExname="";
        //解析请求的内容，提取文件数据
        List<FileItem> fileitems=upload.parseRequest(request);
        //遍历集合
        for(FileItem fileitem:fileitems){
            if(fileitem.isFormField()) {
                //获得字段和字段的值
                map.put(fileitem.getFieldName(), fileitem.getString("utf-8"));
                System.out.println("name:" + fileitem.getFieldName());
                System.out.println("value:" + fileitem.getString("utf-8"));
            }
        }

        for(FileItem fileitem:fileitems){
            if(!fileitem.isFormField()) {
                //获取上传文件的路径
                String filename=fileitem.getName();
                System.out.println("文件来源："+filename);
                //截取文件名
              fileExname=filename.substring(filename.lastIndexOf("/")+1);
                System.out.println("截取的文件名："+fileExname);
                //是文件名保持唯一
//                filename= UUIDUtil.getUUID()+"_"+filename;
//                String webpath="/material/";
//                filepath=getServletContext().getRealPath(webpath+filename);
                filepath=uploadPath+File.separator +filename;
                File storefile=new File(filepath);
                //确保文件路径和父路径没有问题
                System.out.println(filepath);
                storefile.getParentFile().mkdirs();
                storefile.createNewFile();
                fileitem.write(storefile);
                System.out.println("文件上传成功");

            }
        }
        String createTime= DateTimeUtil.getSysTime();//获取当前时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Timestamp create_time=new Timestamp(System.currentTimeMillis());
        create_time=Timestamp.valueOf(createTime);
        String createBy=((User)request.getSession().getAttribute("user")).getId();
        long create_by=Long.parseLong(createBy);
        String url="material/"+fileExname;
        Material m=new Material();
        m.setTitle(map.get("title"));
        m.setDescription(map.get("description"));
        m.setUrl(url);
        m.setCreate_by(create_by);
        m.setCreate_time(create_time);
        MaterialService materialService= (MaterialService) ServiceFactory.getService(new MaterialServiceImpl());
        boolean flag=materialService.save(m);
        if(flag){
            request.getRequestDispatcher("/workbench/activity/material.jsp").forward(request,response);
        }
    }
}
