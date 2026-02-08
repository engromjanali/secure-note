import { createBrowserRouter } from "react-router";
import Layout from "../Layouts/Layout";
import MessageSender from "../Components/MessageSender";
import TitlePage from "../Components/TitlePage";


export const router = createBrowserRouter([
    {
        path:'/',
        element: <Layout></Layout>,
        children: [

           {
                index: true,
                element: <MessageSender></MessageSender>
           },
           {
            path: "title",
            element: <TitlePage></TitlePage>
           }
        ],

    },
 ])