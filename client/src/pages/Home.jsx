import React, { useState, useEffect } from "react"
import { useStateContext } from "../context";
import { DisplayCampaigns } from "../components";

const Home = () => {
    
    const [ isLoading, setIsLoading ] = useState(false);
    const [campaigns, setCampaigns ] = useState([]);

    const { contract, address, getCampaigns } = useStateContext();    

    const fetchCampaigns = async() => {
        setIsLoading(true);
        const data = await getCampaigns();
        setCampaigns(data);
        setIsLoading(false);
    }

    useEffect(()=>{
        if(contract) {
          setIsLoading(true);
          fetchCampaigns();
          setIsLoading(false);
        }
    }, [address, contract])

    return (
        <DisplayCampaigns
          title = "All Campaigns"
          isLoading = {isLoading}
          campaigns = {campaigns}
        />
    )
}

export default Home